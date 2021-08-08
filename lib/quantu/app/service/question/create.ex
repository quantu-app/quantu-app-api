defmodule Quantu.App.Service.Question.Create do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:quiz, Model.Quiz)
    field(:name, :string)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :quiz_id, :name, :type, :prompt, :tags])
    |> validate_required([
      :organization_id,
      :type,
      :prompt
    ])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      question =
        %Model.Question{}
        |> cast(command, [:organization_id, :name, :type, :prompt, :tags])
        |> validate_required([
          :organization_id,
          :type,
          :prompt
        ])
        |> Repo.insert!()

      if Map.get(command, :quiz_id) == nil do
        question
      else
        create_quiz_question_join!(question, command.quiz_id)
      end
    end)
  end

  def question_count(quiz_id),
    do: from(q in Model.QuizQuestionJoin, where: q.quiz_id == ^quiz_id) |> Repo.aggregate(:count)

  def create_quiz_question_join!(%Model.Question{id: question_id} = question, quiz_id) do
    index = question_count(quiz_id)

    %Model.QuizQuestionJoin{quiz_id: quiz_id, question_id: question_id, index: index}
    |> Repo.insert!()

    question
    |> Map.put(:quiz_id, quiz_id)
    |> Map.put(:index, index)
  end
end
