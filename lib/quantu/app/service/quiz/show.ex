defmodule Quantu.App.Service.Quiz.Show do
  use Aicacia.Handler
  import Ecto.Query

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
      from(q in Model.Quiz, where: q.id == ^command.quiz_id, preload: [:questions])
      |> Repo.one!()
    end)
  end
end
