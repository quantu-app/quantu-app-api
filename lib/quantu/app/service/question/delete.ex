defmodule Quantu.App.Service.Question.Delete do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      question = Repo.get!(Model.Question, command.question_id)

      from(qr in Model.QuestionResult,
        where: qr.question_id == ^question.id
      )
      |> Repo.delete_all()

      from(qqj in Model.QuizQuestionJoin,
        where: qqj.quiz_id == ^question.id
      )
      |> Repo.all()
      |> Enum.each(fn quiz_question_join ->
        from(qqj in Model.QuizQuestionJoin,
          where:
            qqj.quiz_id == ^quiz_question_join.quiz_id and qqj.index > ^quiz_question_join.index,
          order_by: [asc: qqj.index]
        )
        |> Repo.all()
        |> Enum.each(fn qqj ->
          qqj
          |> change(index: qqj.index - 1)
          |> Repo.update!()
        end)
      end)

      Repo.delete!(question)
      question
    end)
  end
end
