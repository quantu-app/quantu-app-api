defmodule Quantu.App.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:email, :string, null: false)
      add(:primary, :boolean, default: false, null: false)
      add(:confirmed, :boolean, default: false, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:emails, [:user_id]))
    create(unique_index(:emails, [:email]))
  end
end
