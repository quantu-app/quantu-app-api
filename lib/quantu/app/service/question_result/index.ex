defmodule Quantu.App.Service.QuestionResult.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:quiz, Model.Quiz)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:quiz_id, :user_id])
    |> foreign_key_constraint(:quiz_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      from(q in Model.QuestionResult,
        join: qqj in Model.QuizQuestionJoin,
        on: qqj.question_id == q.question_id and qqj.quiz_id == ^command.quiz_id,
        where: q.user_id == ^command.user_id,
        select: q,
        order_by: [asc: qqj.index]
      )
      |> Repo.all()
    end)
  end
end
