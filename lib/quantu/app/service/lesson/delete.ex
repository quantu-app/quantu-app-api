defmodule Quantu.App.Service.Lesson.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:lesson, Model.Lesson)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:lesson_id])
    |> validate_required([:lesson_id])
    |> foreign_key_constraint(:lesson_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Lesson, command.lesson_id)
      |> Repo.delete!()
    end)
  end
end
