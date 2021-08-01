defmodule Quantu.App.Service.Question.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Question, id: command.question_id)
    end)
  end
end
