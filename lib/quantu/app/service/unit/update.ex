defmodule Quantu.App.Service.Unit.Update do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:unit, Model.Unit)
    belongs_to(:course, Model.Course)
    field(:index, :integer)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:unit_id, :course_id, :index, :name, :description, :tags, :published])
    |> validate_required([:unit_id])
    |> foreign_key_constraint(:unit_id)
    |> foreign_key_constraint(:course_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      unit =
        Repo.get_by!(Model.Unit, id: command.unit_id)
        |> cast(command, [:name, :description, :tags, :published])
        |> Repo.update!()
        |> Map.put(:course_id, Map.get(command, :course_id))
        |> Map.put(:index, Map.get(command, :index))

      if unit.course_id == nil do
        unit
      else
        update_unit_index!(unit, unit.course_id, unit.index)
      end
    end)
  end

  def update_unit_index!(%Model.Unit{id: unit_id} = unit, course_id, nil) do
    case Repo.get_by!(Model.CourseUnitJoin,
           course_id: course_id,
           unit_id: unit_id
         ) do
      nil ->
        Service.Course.Create.create_course_unit_join!(unit, course_id)

      course_unit_join ->
        unit
        |> Map.put(:course_id, course_id)
        |> Map.put(:index, course_unit_join.index)
    end
  end

  def update_unit_index!(%Model.Unit{id: unit_id} = unit, course_id, index) do
    max_index = Service.Course.Create.children_count(course_id) - 1

    index =
      cond do
        index < 0 -> 0
        index > max_index -> max_index
        true -> index
      end

    {course_unit_join, is_new} =
      case Repo.get_by!(Model.CourseUnitJoin,
             course_id: course_id,
             unit_id: unit_id
           ) do
        nil ->
          {%Model.CourseUnitJoin{course_id: course_id, unit_id: unit_id, index: index}
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
        update_course_indices_below_index(course_id, unit_id, index)
      end

      if index < max_index do
        update_course_indices_above_index(course_id, unit_id, index)
      end
    end

    unit
    |> Map.put(:course_id, course_id)
    |> Map.put(:index, index)
  end

  defp update_course_indices_below_index(course_id, unit_id, index) do
    {changes, _last_index} =
      from(cuj in Model.CourseUnitJoin,
        where: cuj.unit_id != ^unit_id and cuj.course_id == ^course_id and cuj.index <= ^index,
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

  defp update_course_indices_above_index(course_id, unit_id, index) do
    {changes, _last_index} =
      from(cuj in Model.CourseUnitJoin,
        where: cuj.unit_id != ^unit_id and cuj.course_id == ^course_id and cuj.index >= ^index,
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
