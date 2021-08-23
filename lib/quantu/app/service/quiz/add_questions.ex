defmodule Quantu.App.Service.Quiz.AddQuestions do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:quiz, Model.Quiz)
    field(:questions, {:array, :integer}, null: false)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:quiz_id, :questions])
    |> validate_required([:quiz_id, :questions])
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      index = Service.Question.Create.question_count(command.quiz_id)

      {questions, _last_index} =
        command.questions
        |> Enum.map_reduce(index, fn question_id, index ->
          {%{question_id: question_id, quiz_id: command.quiz_id, index: index}, index + 1}
        end)

      Repo.insert_all(
        Model.QuizQuestionJoin,
        questions,
        on_conflict: :nothing
      )
    end)
  end
end
