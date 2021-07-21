defmodule AicaciaId.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add(
        :deck_id,
        references(:decks, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:front, {:array, :map}, null: false, default: [])
      add(:back, {:array, :map}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:cards, [:deck_id]))
  end
end
