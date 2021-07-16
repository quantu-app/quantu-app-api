defmodule Quantu.App.Service.Document.Update do
  use Aicacia.Handler
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:document, Model.Document, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string, null: false)
    field(:language, :string, null: false, default: "en")
    field(:word_count, :integer, null: false, default: 0)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:document_id, :user_id, :name, :language, :word_count, :tags])
    |> validate_required([:document_id, :user_id])
    |> foreign_key_constraint(:document_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Document, id: command.document_id, user_id: command.user_id)
      |> cast(command, [:name, :language, :word_count, :tags])
      |> Repo.update!()
    end)
  end
end
