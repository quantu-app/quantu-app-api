defmodule Quantu.App.Repo.Migrations.CreateUserOrganizationSubscriptions do
  use Ecto.Migration

  def change do
    create table(:user_organization_subscriptions) do
      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
      add(
        :organization_id,
        references(:organizations, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
    end

    create(index(:user_organization_subscriptions, [:user_id]))
    create(index(:user_organization_subscriptions, [:organization_id]))
    create(unique_index(:user_organization_subscriptions, [:user_id, :organization_id]))
  end
end
