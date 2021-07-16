defmodule AicaciaId.Repo.Migrations.CreateJournels do
  use Ecto.Migration

  def change do
    create table(:journels, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:name, :string, null: false)
      add(:content, {:array, :map}, null: false, default: [])
      add(:language, :string, null: false, default: "en")
      add(:word_count, :integer, null: false, default: 0)
      add(:tags, {:array, :string}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end
  end
end
