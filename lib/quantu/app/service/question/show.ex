defmodule Quantu.App.Service.Question.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question)
    belongs_to(:quiz, Model.Quiz)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id, :quiz_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :quiz_id) == nil do
        Repo.get_by!(Model.Question, id: command.question_id)
      else
        {question, quiz_question_join} = from(q in Model.Question,
          join: qqj in Model.QuizQuestionJoin,
          on: qqj.question_id == q.id and qqj.quiz_id == ^command.quiz_id,
          where: q.id == ^command.question_id,
          select: {q, qqj}
        )
        |> Repo.one!()

        question
        |> Map.put(:index, quiz_question_join.index)
        |> Map.put(:quiz_id, quiz_question_join.quiz_id)
      end
    end)
  end
end
