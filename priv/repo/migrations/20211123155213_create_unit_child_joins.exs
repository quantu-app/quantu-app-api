defmodule AicaciaId.Repo.Migrations.CreateUnitChildJoins do
  use Ecto.Migration

  def change do
    create table(:unit_child_joins) do
      add(
        :unit_id,
        references(:units, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
      add(
        :quiz_id,
        references(:quizzes, on_delete: :delete_all, on_update: :nothing),
        null: true
      )
      add(
        :lesson_id,
        references(:lessons, on_delete: :delete_all, on_update: :nothing),
        null: true
      )

      add(:index, :integer, null: false)
    end

    create(index(:unit_child_joins, [:unit_id]))
    create(index(:unit_child_joins, [:quiz_id]))
    create(index(:unit_child_joins, [:lesson_id]))
  end
end
