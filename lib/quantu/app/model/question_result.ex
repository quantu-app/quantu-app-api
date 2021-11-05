defmodule Quantu.App.Model.QuestionResult do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "question_results" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:question, Model.Question)

    field(:answered, :integer, null: false, default: 0)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:answer, :map, null: false)
    field(:result, :float, null: false)

    timestamps(type: :utc_datetime)
  end
end
