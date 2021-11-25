defmodule AicaciaId.Repo.Migrations.CreateCourseUnitJoins do
  use Ecto.Migration

  def change do
    create table(:course_unit_joins) do
      add(
        :course_id,
        references(:courses, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
      add(
        :unit_id,
        references(:units, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:index, :integer, null: false)
    end

    create(index(:course_unit_joins, [:course_id]))
    create(index(:course_unit_joins, [:unit_id]))
  end
end
