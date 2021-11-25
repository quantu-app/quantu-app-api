defmodule Quantu.App.Service.Lesson.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:lesson, Model.Lesson)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:content, {:array, :map}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:lesson_id, :name, :description, :tags, :published, :content])
    |> validate_required([:lesson_id])
    |> foreign_key_constraint(:lesson_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Lesson, id: command.lesson_id)
      |> cast(command, [:name, :description, :tags, :published, :content])
      |> Repo.update!()
    end)
  end
end
