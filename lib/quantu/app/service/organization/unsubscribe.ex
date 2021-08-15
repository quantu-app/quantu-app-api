defmodule Quantu.App.Service.Organization.Unsubscribe do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:organization, Model.Organization)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([:user_id, :organization_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.UserOrganizationSubscription,
        user_id: command.user_id,
        organization_id: command.organization_id
      )
      |> Repo.delete!()
    end)
  end
end
