defmodule Quantu.App.Model.UserOrganizationSubscription do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "user_organization_subscriptions" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:organization, Model.Organization)
  end
end
