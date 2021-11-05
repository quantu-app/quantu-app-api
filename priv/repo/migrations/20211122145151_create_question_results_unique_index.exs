defmodule AicaciaId.Repo.Migrations.CreateQuestionResultsUniqueIndex do
  use Ecto.Migration

  def change do
    create(unique_index(:question_results, [:user_id, :question_id]))
  end
end
