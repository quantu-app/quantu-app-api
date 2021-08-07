defmodule Quantu.App.Service.Quiz.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :organization_id) == nil do
        from(q in Model.Quiz)
        |> Repo.all()
      else
        from(q in Model.Quiz,
          where: q.organization_id == ^command.organization_id,
        )
        |> Repo.all()
      end
    end)
  end
end
