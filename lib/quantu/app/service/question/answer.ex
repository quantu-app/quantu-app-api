defmodule Quantu.App.Service.Question.Answer do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question)
    field(:answer, :map)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id, :answer])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %{type: type, prompt: prompt} = Repo.get_by!(Model.Question, id: command.question_id)
      correct(type, prompt, Map.get(command.answer, :input))
    end)
  end

  defp correct("flash_card", _prompt, input) when is_float(input) or is_integer(input) do
    cond do
      input < 0 -> 0
      input > 1 -> 1
      true -> input
    end
  end

  defp correct("flash_card", _prompt, _input), do: 0

  defp correct("multiple_choice", %{"choices" => choices}, input)
       when is_binary(input) or is_bitstring(input),
       do: correct("multiple_choice", %{"choices" => choices}, [input])

  defp correct("multiple_choice", %{"choices" => choices}, input) when is_list(input) do
    {correct, total} =
      choices
      |> Enum.reduce({0, 0}, fn {key, choice}, {correct, total} ->
        is_correct_choice = Map.get(choice, "correct")

        {
          if is_correct_choice and Enum.any?(input, fn k -> k == key end) do
            correct + 1
          else
            correct
          end,
          if is_correct_choice do
            total + 1
          else
            total
          end
        }
      end)

    if total == 0 do
      correct / total
    else
      1
    end
  end

  defp correct(_type, _prompt, _input), do: 0
end
