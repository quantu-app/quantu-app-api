defmodule AicaciaId.Repo.Migrations.CreateQuizzess do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add(
        :organization_id,
        references(:organizations, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:name, :string, null: false)
      add(:description, :string, null: false, default: "")
      add(:tags, {:array, :string}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:quizzes, [:organization_id]))
  end
end
