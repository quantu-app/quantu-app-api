defmodule AicaciaId.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add(:organization_id, references(:organizations, on_delete: :delete_all, on_update: :nothing), null: false)

      add(:name, :string, null: false)
      add(:published, :boolean, null: false, default: false)
      add(:description, :string, null: false, default: "")
      add(:tags, {:array, :string}, null: false, default: [])

      timestamps(type: :utc_datetime)
    end

    create(index(:courses, [:organization_id]))
  end
end
