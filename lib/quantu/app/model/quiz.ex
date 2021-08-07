defmodule Quantu.App.Model.Quiz do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "quizzes" do
    belongs_to(:organization, Model.Organization, type: :binary_id)
    many_to_many(:questions, Model.Question, join_through: Model.QuizQuestionJoin)

    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
