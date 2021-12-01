defmodule Quantu.App.Service.Course.Create do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :name, :description, :tags, :published])
    |> validate_required([
      :organization_id,
      :name
    ])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Course{}
      |> cast(command, [:organization_id, :name, :description, :tags, :published])
      |> validate_required([
        :organization_id,
        :name
      ])
      |> Repo.insert!()
    end)
  end

  def children_count(course_id),
    do:
      from(q in Model.CourseUnitJoin, where: q.course_id == ^course_id) |> Repo.aggregate(:count)

  def create_course_unit_join!(%{id: unit_id} = unit, course_id) do
    index = children_count(course_id)

    %Model.CourseUnitJoin{course_id: course_id, unit_id: unit_id, index: index}
    |> Repo.insert!()

    unit
    |> Map.put(:course_id, course_id)
    |> Map.put(:index, index)
  end
end
