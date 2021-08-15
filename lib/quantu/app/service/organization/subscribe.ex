defmodule Quantu.App.Service.Organization.Subscribe do
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
      %Model.UserOrganizationSubscription{}
      |> cast(command, [:user_id, :organization_id])
      |> unique_constraint([:user_id, :organization_id],
        name: :user_organization_subscriptions_user_id_organization_id_index
      )
      |> Repo.insert!()
    end)
  end
end
