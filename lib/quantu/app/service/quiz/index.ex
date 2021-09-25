defmodule Quantu.App.Service.Quiz.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :published])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query =
        if Map.get(command, :organization_id) == nil,
          do: Model.Quiz,
          else:
            from(q in Model.Quiz,
              where: q.organization_id == ^command.organization_id
            )

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [q], q.published == ^command.published)

      query = order_by(query, [q], asc: q.inserted_at)

      Repo.all(query)
    end)
  end
end
