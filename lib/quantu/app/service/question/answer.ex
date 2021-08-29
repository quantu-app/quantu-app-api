defmodule Quantu.App.Service.Question.Answer do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:question, Model.Question)
    field(:answer, :map)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :question_id, :answer])
    |> validate_required([:user_id, :question_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Question{type: type, prompt: prompt} = Repo.get!(Model.Question, command.question_id)
      result = correct(type, prompt, Map.get(command.answer, :input))

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
            answer: command.answer,
            result: result
          }
          |> Repo.insert!()

        question_result ->
          question_result
          |> change(
            answered: question_result.answered + 1,
            type: type,
            prompt: prompt,
            answer: command.answer,
            result: result
          )
          |> Repo.update!()
      end
    end)
  end

  defp correct("flash_card", _prompt, input) when is_float(input) or is_integer(input) do
    cond do
      input < 0 -> 0.0
      input > 1 -> 1.0
      true -> input / 1
    end
  end

  defp correct("flash_card", _prompt, _input), do: 0

  defp correct("multiple_choice", %{"choices" => choices}, input)
       when is_binary(input) or is_bitstring(input),
       do: correct("multiple_choice", %{"choices" => choices}, [input])

  defp correct("multiple_choice", %{"choices" => choices}, input) when is_list(input) do
    correct =
      input
      |> Enum.reduce(0, fn key, correct ->
        if Map.get(choices, key, %{}) |> Map.get("correct") == true do
          correct + 1
        else
          correct
        end
      end)

    total =
      choices
      |> Enum.reduce(0, fn {_key, choice}, total ->
        if Map.get(choice, "correct") == true do
          total + 1
        else
          total
        end
      end)

    if total == 0 do
      0.0
    else
      correct / total
    end
  end

  defp correct(_type, _prompt, _input), do: 0
end
