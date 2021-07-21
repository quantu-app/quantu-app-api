defmodule AicaciaId.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:name, :string, null: false)
      add(:tags, {:array, :string}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:decks, [:user_id]))
  end
end
