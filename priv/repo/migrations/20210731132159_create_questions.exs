defmodule AicaciaId.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:organization_id, references(:organizations, on_delete: :delete_all, on_update: :nothing), null: false)

      add(:type, :string, null: false)
      add(:prompt, :map, null: false)
      add(:tags, {:array, :string}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:questions, [:organization_id]))
  end
end
