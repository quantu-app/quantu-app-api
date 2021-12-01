defmodule Quantu.App.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add(
        :organization_id,
        references(:organizations, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:name, :string, null: false)
      add(:description, :string, null: false, default: "")
      add(:tags, {:array, :string}, null: false, default: [])
      add(:published, :boolean, null: false, default: false)
      add(:content, {:array, :map}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:lessons, [:organization_id]))
  end
end
