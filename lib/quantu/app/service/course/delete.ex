defmodule Quantu.App.Service.Course.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:course, Model.Course)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:course_id])
    |> validate_required([:course_id])
    |> foreign_key_constraint(:course_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Course, command.course_id)
      |> Repo.delete!()
    end)
  end
end
