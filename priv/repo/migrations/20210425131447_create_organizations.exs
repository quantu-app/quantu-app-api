defmodule AicaciaId.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:name, :string, null: false)
      add(:url, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:organizations, [:user_id]))
    create(unique_index(:organizations, [:url]))
  end
end
