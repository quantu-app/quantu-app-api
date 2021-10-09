defmodule Quantu.App.Service.Asset.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:parent, Model.Asset)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :parent_id])
    |> validate_required([:organization_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:parent_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query =
        if Map.get(command, :organization_id) == nil,
          do: Model.Asset,
          else:
            from(q in Model.Asset,
              where: q.organization_id == ^command.organization_id
            )

      query =
        if Map.get(command, :parent_id) == nil,
          do: where(query, [q], is_nil(q.parent_id)),
          else: where(query, [q], q.parent_id == ^command.parent_id)

      query = order_by(query, [q], asc: q.inserted_at)

      Repo.all(query)
    end)
  end
end
