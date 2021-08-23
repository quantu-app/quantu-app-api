defmodule AicaciaId.Repo.Migrations.CreateQuestionResults do
  use Ecto.Migration

  def change do
    create table(:question_results) do
      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
      add(:question_id, references(:questions, on_delete: :nothing, on_update: :nothing), null: false)

      add(:answered, :integer, null: false, default: 1)
      add(:type, :string, null: false)
      add(:prompt, :map, null: false)
      add(:answer, :map, null: false)
      add(:result, :float, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:question_results, [:user_id]))
    create(index(:question_results, [:question_id]))
  end
end
