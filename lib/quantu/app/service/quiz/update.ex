defmodule Quantu.App.Service.Quiz.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:quiz, Model.Quiz)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:quiz_id, :name, :description, :tags, :published])
    |> validate_required([:quiz_id])
    |> foreign_key_constraint(:quiz_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Quiz, id: command.quiz_id)
      |> cast(command, [:name, :description, :tags, :published])
      |> Repo.update!()
    end)
  end
end
