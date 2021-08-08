defmodule Quantu.App.Service.Organization.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id])
    |> validate_required([:organization_id])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Organization, id: command.organization_id)
    end)
  end
end
