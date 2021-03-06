defmodule Quantu.App.Model.Quiz do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "quizzes" do
    belongs_to(:organization, Model.Organization)
    many_to_many(:questions, Model.Question, join_through: Model.QuizQuestionJoin)

    field(:published, :boolean, null: false, default: false)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])

    field(:index, :integer, virtual: true)
    field(:unit_id, :integer, virtual: true)
    field(:type, :string, virtual: true)

    timestamps(type: :utc_datetime)
  end
end
