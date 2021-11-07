defmodule Quantu.App.Service.QuestionResult.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:question, Model.QuestionResult)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id, :user_id])
    |> validate_required([:question_id, :user_id])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.QuestionResult,
        question_id: command.question_id,
        user_id: command.user_id
      )
    end)
  end
end
