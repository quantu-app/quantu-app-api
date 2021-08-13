defmodule Quantu.App.Service.Question.Update do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:quiz, Model.Quiz)
    belongs_to(:question, Model.Question)
    field(:name, :string)
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
      :name,
      :type,
      :prompt,
      :index,
      :tags
    ])
    |> validate_required([
      :question_id
    ])
    |> foreign_key_constraint(:quiz_id)
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      question =
        Repo.get_by!(Model.Question, id: command.question_id)
        |> cast(command, [:name, :type, :prompt, :tags])
        |> Repo.update!()

      if Map.get(command, :quiz_id) == nil do
        question
      else
        update_question_index!(question, command.quiz_id, Map.get(command, :index))
      end
    end)
  end

  def update_question_index!(%Model.Question{id: question_id} = question, quiz_id, nil) do
    case Repo.get_by!(Model.QuizQuestionJoin,
           quiz_id: quiz_id,
           question_id: question_id
         ) do
      nil ->
        Service.Question.Create.create_quiz_question_join!(question, quiz_id)

      quiz_question_join ->
        question
        |> Map.put(:quiz_id, quiz_id)
        |> Map.put(:index, quiz_question_join.index)
    end
  end

  def update_question_index!(%Model.Question{id: question_id} = question, quiz_id, index) do
    max_index = Service.Question.Create.question_count(quiz_id) - 1

    index =
      cond do
        index < 0 -> 0
        index > max_index -> max_index
        true -> index
      end

    {quiz_question_join, is_new} =
      case Repo.get_by!(Model.QuizQuestionJoin,
             quiz_id: quiz_id,
             question_id: question_id
           ) do
        nil ->
          {%Model.QuizQuestionJoin{quiz_id: quiz_id, question_id: question_id, index: index}
           |> Repo.insert!(), true}

        quiz_question_join ->
          {quiz_question_join, false}
      end

    if not is_new do
      quiz_question_join
      |> change(index: index)
      |> Repo.update!()
    end

    if quiz_question_join.index != index or is_new do
      if index > 0 do
        update_quiz_indices_below_index(quiz_id, question_id, index)
      end

      if index < max_index do
        update_quiz_indices_above_index(quiz_id, question_id, index)
      end
    end

    question
    |> Map.put(:quiz_id, quiz_id)
    |> Map.put(:index, index)
  end

  defp update_quiz_indices_below_index(quiz_id, question_id, index) do
    {changes, _last_index} =
      from(qqj in Model.QuizQuestionJoin,
        where:
          qqj.question_id != ^question_id and qqj.quiz_id == ^quiz_id and qqj.index <= ^index,
        order_by: [asc: qqj.index]
      )
      |> Repo.all()
      |> Enum.reduce({[], 0}, fn quiz_question_join, {quiz_question_joins, index} ->
        {
          quiz_question_joins ++ [change(quiz_question_join, index: index)],
          index + 1
        }
      end)

    Enum.each(changes, &Repo.update!/1)
  end

  defp update_quiz_indices_above_index(quiz_id, question_id, index) do
    {changes, _last_index} =
      from(qqj in Model.QuizQuestionJoin,
        where:
          qqj.question_id != ^question_id and qqj.quiz_id == ^quiz_id and qqj.index >= ^index,
        order_by: [asc: qqj.index]
      )
      |> Repo.all()
      |> Enum.reduce({[], index + 1}, fn quiz_question_join, {quiz_question_joins, index} ->
        {
          quiz_question_joins ++ [change(quiz_question_join, index: index)],
          index + 1
        }
      end)

    Enum.each(changes, &Repo.update!/1)
  end
end
