defmodule Quantu.App.Service.Question.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:question_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Question, command.question_id)
      |> Repo.delete!()
    end)
  end
end
