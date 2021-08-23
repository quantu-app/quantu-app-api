defmodule Quantu.App.Service.Quiz.RemoveQuestions do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

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
      from(qqj in Model.QuizQuestionJoin,
        where: qqj.quiz_id == ^command.quiz_id and qqj.question_id in ^command.questions
      )
      |> Repo.delete_all()

      {changes, _last_index} =
        from(qqj in Model.QuizQuestionJoin,
          where: qqj.quiz_id == ^command.quiz_id,
          order_by: [asc: qqj.index]
        )
        |> Repo.all()
        |> Enum.map_reduce(0, fn quiz_question_join, index ->
          {
            change(quiz_question_join, index: index),
            index + 1
          }
        end)

      Enum.each(changes, &Repo.update!/1)
    end)
  end
end
