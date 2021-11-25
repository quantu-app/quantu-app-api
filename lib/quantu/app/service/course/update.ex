defmodule Quantu.App.Service.Course.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:course, Model.Course)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:course_id, :name, :description, :tags, :published])
    |> validate_required([:course_id])
    |> foreign_key_constraint(:course_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Course, id: command.course_id)
      |> cast(command, [:name, :description, :tags, :published])
      |> Repo.update!()
    end)
  end
end
