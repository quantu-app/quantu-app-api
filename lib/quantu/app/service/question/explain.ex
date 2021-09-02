defmodule Quantu.App.Service.Question.Explain do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:question, Model.Question)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :question_id])
    |> validate_required([:user_id, :question_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Question{type: type, prompt: prompt} = Repo.get!(Model.Question, command.question_id)

      case Repo.get_by(Model.QuestionResult,
             question_id: command.question_id,
             user_id: command.user_id
           ) do
        nil ->
          %Model.QuestionResult{
            question_id: command.question_id,
            user_id: command.user_id,
            type: type,
            prompt: prompt,
            answer: %{input: "explained"},
            result: 0.0
          }
          |> Repo.insert!()

        question_result ->
          question_result
          |> change(
            answered: question_result.answered + 1,
            type: type,
            prompt: prompt,
            answer: %{input: "explained"},
            result: 0.0
          )
          |> Repo.update!()
      end
    end)
  end
end
