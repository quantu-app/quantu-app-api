defmodule Quantu.App.Service.Lesson.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:unit, Model.Unit)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :unit_id, :published])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:unit_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query = Model.Lesson

      query =
        if Map.get(command, :organization_id) == nil,
          do: query,
          else:
            query
            |> where([q], q.organization_id == ^command.organization_id)
            |> order_by([q], asc: q.inserted_at)

      query =
        if Map.get(command, :unit_id) == nil,
          do: query,
          else:
            query
            |> join(:left, [q], cqj in Model.UnitChildJoin, on: cqj.quiz_id == q.id)
            |> where([q, cqj], cqj.unit_id == ^command.unit_id)
            |> order_by([q, cqj], asc: cqj.index)

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [q], q.published == ^command.published)

      query = order_by(query, [q], asc: q.inserted_at)

      Repo.all(query)
    end)
  end
end
