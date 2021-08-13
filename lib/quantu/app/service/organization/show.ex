defmodule Quantu.App.Service.Organization.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:organization, Model.Organization)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :user_id])
    |> validate_required([:organization_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :user_id) == nil do
        Repo.get!(Model.Organization, command.organization_id)
      else
        Repo.get_by!(Model.Organization, id: command.organization_id, user_id: command.user_id)
      end
    end)
  end
end
