defmodule Quantu.App.Repo.Migrations.CreateQuizQuestionJoins do
  use Ecto.Migration

  def change do
    create table(:quiz_question_joins) do
      add(
        :quiz_id,
        references(:quizzes, on_delete: :delete_all, on_update: :nothing),
        null: false
      )
      add(
        :question_id,
        references(:questions, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:index, :integer, null: false)
    end

    create(index(:quiz_question_joins, [:quiz_id]))
    create(index(:quiz_question_joins, [:question_id]))
  end
end
