defmodule Quantu.App.Service.Document.Show do
  use Aicacia.Handler
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:document, Model.Document, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:document_id, :user_id])
    |> validate_required([:document_id, :user_id])
    |> foreign_key_constraint(:document_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Document, id: command.document_id, user_id: command.user_id)
    end)
  end
end
