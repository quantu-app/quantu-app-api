defmodule Quantu.App.Service.Unit.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:course, Model.Course)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :course_id, :published])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:course_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query = Model.Unit

      query =
        if Map.get(command, :organization_id) == nil,
          do: query,
          else:
            query
            |> where([u], u.organization_id == ^command.organization_id)
            |> order_by([u], asc: u.inserted_at)

      query =
        if Map.get(command, :course_id) == nil,
          do: query,
          else:
            query
            |> join(:left, [u], cuj in Model.CourseUnitJoin, on: cuj.unit_id == u.id)
            |> where([u, cuj], cuj.course_id == ^command.course_id)
            |> order_by([u, cuj], asc: cuj.index)
            |> select_merge([u, cuj], %{index: cuj.index, course_id: cuj.course_id})

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [u], u.published == ^command.published)

      Repo.all(query)
    end)
  end
end
