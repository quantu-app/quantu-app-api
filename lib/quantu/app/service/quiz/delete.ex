defmodule Quantu.App.Service.Quiz.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:quiz, Model.Quiz)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:quiz_id])
    |> validate_required([:quiz_id])
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Quiz, command.quiz_id)
      |> Repo.delete!()
    end)
  end
end
