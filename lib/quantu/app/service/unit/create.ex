defmodule Quantu.App.Service.Unit.Create do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:course, Model.Course)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :course_id, :name, :description, :tags, :published])
    |> validate_required([
      :organization_id,
      :name
    ])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      unit =
        %Model.Unit{}
        |> cast(command, [:organization_id, :name, :description, :tags, :published])
        |> validate_required([
          :organization_id,
          :name
        ])
        |> Repo.insert!()

      if Map.get(command, :course_id) == nil do
        unit
      else
        Service.Course.Create.create_course_unit_join!(unit, command.course_id)
      end
    end)
  end

  def children_count(unit_id) do
    from(uqj in Model.UnitChildJoin, where: uqj.unit_id == ^unit_id)
    |> Repo.aggregate(:count)
  end

  def create_unit_child_join!(%Model.Lesson{id: lesson_id} = lesson, unit_id),
    do: create_unit_child_join!(lesson, :lesson_id, lesson_id, unit_id)

  def create_unit_child_join!(%Model.Quiz{id: quiz_id} = quiz, unit_id),
    do: create_unit_child_join!(quiz, :quiz_id, quiz_id, unit_id)

  defp create_unit_child_join!(%{} = child, child_id_key, child_id, unit_id) do
    index = Service.Unit.Create.children_count(unit_id)

    %Model.UnitChildJoin{unit_id: unit_id, index: index}
    |> Map.put(child_id_key, child_id)
    |> Repo.insert!()

    child
    |> Map.put(:unit_id, unit_id)
    |> Map.put(:index, index)
  end
end
