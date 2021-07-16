defmodule Quantu.App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(:active, :boolean, default: true, null: false)
      add(:username, :string, null: false)
      add(:encrypted_password, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:username]))
  end
end
