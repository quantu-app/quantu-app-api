defmodule Quantu.App.Service.Lesson.Update do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:lesson, Model.Lesson)
    belongs_to(:unit, Model.Unit)
    field(:index, :integer)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])
    field(:content, {:array, :map}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :lesson_id,
      :unit_id,
      :index,
      :name,
      :description,
      :tags,
      :published,
      :content
    ])
    |> validate_required([:lesson_id])
    |> foreign_key_constraint(:lesson_id)
    |> foreign_key_constraint(:unit_id)
  end

  def handle(%{} = command) do
    IO.inspect(command)

    Repo.run(fn ->
      lesson =
        Repo.get_by!(Model.Lesson, id: command.lesson_id)
        |> cast(command, [:name, :description, :tags, :published, :content])
        |> Repo.update!()
        |> Map.put(:index, Map.get(command, :index))
        |> Map.put(:unit_id, Map.get(command, :unit_id))

      if lesson.unit_id == nil do
        lesson
      else
        update_quiz_index!(lesson, lesson.unit_id, lesson.index)
      end
    end)
  end

  def update_quiz_index!(%Model.Lesson{id: lesson_id} = lesson, unit_id, nil) do
    case Repo.get_by!(Model.UnitChildJoin,
           lesson_id: lesson_id,
           unit_id: unit_id
         ) do
      nil ->
        Service.Unit.Create.create_unit_child_join!(lesson, unit_id)

      unit_child_join ->
        lesson
        |> Map.put(:unit_id, unit_id)
        |> Map.put(:index, unit_child_join.index)
    end
  end

  def update_quiz_index!(%Model.Lesson{id: lesson_id} = lesson, unit_id, index) do
    max_index = Service.Unit.Create.children_count(unit_id) - 1

    index =
      cond do
        index < 0 -> 0
        index > max_index -> max_index
        true -> index
      end

    {course_unit_join, is_new} =
      case Repo.get_by!(Model.UnitChildJoin,
             lesson_id: lesson_id,
             unit_id: unit_id
           ) do
        nil ->
          {%Model.UnitChildJoin{lesson_id: lesson_id, unit_id: unit_id, index: index}
           |> Repo.insert!(), true}

        course_unit_join ->
          {course_unit_join, false}
      end

    if not is_new do
      course_unit_join
      |> change(index: index)
      |> Repo.update!()
    end

    if course_unit_join.index != index or is_new do
      if index > 0 do
        update_course_indices_below_index(lesson_id, unit_id, index)
      end

      if index < max_index do
        update_course_indices_above_index(lesson_id, unit_id, index)
      end
    end

    lesson
    |> Map.put(:unit_id, unit_id)
    |> Map.put(:index, index)
  end

  defp update_course_indices_below_index(lesson_id, unit_id, index) do
    {changes, _last_index} =
      from(cuj in Model.UnitChildJoin,
        where: cuj.lesson_id != ^lesson_id and cuj.unit_id == ^unit_id and cuj.index <= ^index,
        order_by: [asc: cuj.index]
      )
      |> Repo.all()
      |> Enum.map_reduce(0, fn course_unit_join, index ->
        {
          change(course_unit_join, index: index),
          index + 1
        }
      end)

    Enum.each(changes, &Repo.update!/1)
  end

  defp update_course_indices_above_index(lesson_id, unit_id, index) do
    {changes, _last_index} =
      from(cuj in Model.UnitChildJoin,
        where: cuj.lesson_id != ^lesson_id and cuj.unit_id == ^unit_id and cuj.index >= ^index,
        order_by: [asc: cuj.index]
      )
      |> Repo.all()
      |> Enum.map_reduce(index + 1, fn course_unit_join, index ->
        {
          change(course_unit_join, index: index),
          index + 1
        }
      end)

    Enum.each(changes, &Repo.update!/1)
  end
end
