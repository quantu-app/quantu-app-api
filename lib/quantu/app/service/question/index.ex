defmodule Quantu.App.Service.Question.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:quiz, Model.Quiz)
    field(:is_challenge, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :quiz_id, :is_challenge])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query = from(q in Model.Question)

      query =
        if Map.get(command, :organization_id) == nil do
          query
        else
          where(query, [q], q.organization_id == ^command.organization_id)
        end

      query =
        if Map.get(command, :is_challenge) == nil do
          query
        else
          where(query, [q], q.is_challenge == ^command.is_challenge)
        end

      if Map.get(command, :quiz_id) == nil do
        Repo.all(query)
      else
        join(query, :inner, [q], qqj in Model.QuizQuestionJoin,
          on: qqj.question_id == q.id and qqj.quiz_id == ^command.quiz_id
        )
        |> order_by([q, qqj], asc: qqj.index)
        |> select([q, qqj], {q, qqj})
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
