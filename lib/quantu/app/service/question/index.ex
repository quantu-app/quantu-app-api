defmodule Quantu.App.Service.Question.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization, type: :binary_id)
    belongs_to(:quiz, Model.Quiz)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :quiz_id])
    |> validate_required([:organization_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :quiz_id) == nil do
        from(q in Model.Question, where: q.organization_id == ^command.organization_id)
        |> Repo.all()
      else
        from(q in Model.Question,
          join: qqj in Model.QuizQuestionJoin,
          on: qqj.question_id == q.id and qqj.quiz_id == ^command.quiz_id,
          where: q.organization_id == ^command.organization_id,
          order_by: [asc: qqj.index],
          select: {q, qqj}
        )
        |> Repo.all()
        |> Enum.map(fn {question, qqj} ->
          question
          |> Map.put(:index, qqj.index)
          |> Map.put(:quiz_id, qqj.quiz_id)
        end)
      end
    end)
  end
end
