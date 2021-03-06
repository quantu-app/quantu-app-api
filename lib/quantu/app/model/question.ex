defmodule Quantu.App.Model.Question do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "questions" do
    belongs_to(:organization, Model.Organization)
    many_to_many(:quizzes, Model.Question, join_through: Model.QuizQuestionJoin)

    field(:name, :string)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:tags, {:array, :string}, null: false, default: [])

    field(:is_challenge, :boolean, null: false, default: false)
    field(:released_at, :utc_datetime)

    timestamps(type: :utc_datetime)
  end
end
