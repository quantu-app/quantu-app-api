defmodule Quantu.App.Service.Question.Update do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:quiz, Model.Quiz)
    belongs_to(:question, Model.Question)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:index, :integer)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :quiz_id,
      :question_id,
      :type,
      :prompt,
      :index,
      :tags
    ])
    |> validate_required([
      :question_id,
      :type,
      :prompt,
      :tags
    ])
    |> foreign_key_constraint(:quiz_id)
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      question =
        Repo.get_by!(Model.Question, id: command.question_id)
        |> cast(command, [:type, :prompt, :tags])
        |> Repo.update!()

      if Map.get(command, :quiz_id) == nil do
        question
      else
        if Map.get(command, :index) == nil do
          Service.Question.Create.create_quiz_question_join!(question, command.quiz_id)
        else
          update_question_index!(question, command.quiz_id, command.index)
        end
      end
    end)
  end

  def update_question_index!(%Model.Question{id: question_id} = question, quiz_id, index) do
    if index < 0 or index > Service.Question.Create.question_count(quiz_id) do
      raise ArgumentError, message: "invalid index " <> to_string(index)
    end

    quiz_question_join =
      case Repo.get_by!(Model.QuizQuestionJoin,
             quiz_id: quiz_id,
             question_id: question_id
           ) do
        nil ->
          Service.Question.Create.create_quiz_question_join!(question, quiz_id)

        quiz_question_join ->
          quiz_question_join
      end

    quiz_question_join
    |> change(index: index)
    |> Repo.update!()

    {changes, _last_index} = from(qqj in Model.QuizQuestionJoin,
      where: qqj.quiz_id == ^quiz_id and qqj.index >= ^index,
      order_by: [asc: qqj.index]
    )
    |> Repo.all()
    |> Enum.reduce({[], index + 1}, fn quiz_question_join, {quiz_question_joins, index} ->
      {
        quiz_question_joins ++ [change(quiz_question_join, index: index)],
        index + 1
      }
    end)

    Enum.map(changes, &Repo.update!/1)

    question
    |> Map.put(:quiz_id, quiz_id)
    |> Map.put(:index, index)
  end
end
