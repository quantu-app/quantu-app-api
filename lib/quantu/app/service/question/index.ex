defmodule Quantu.App.Service.Question.Index do
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
    |> validate_required([:organization_id])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      from(b in Model.Question,
        where:
          b.organization_id ==
            ^command.organization_id
      )
      |> Repo.all()
    end)
  end
end
