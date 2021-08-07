defmodule Quantu.App.Model.QuizQuestionJoin do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "quiz_question_joins" do
    belongs_to(:quiz, Model.Quiz)
    belongs_to(:question, Model.Question)

    field(:index, :integer, null: false)
  end
end
