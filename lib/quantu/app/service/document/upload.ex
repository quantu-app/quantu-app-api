defmodule Quantu.App.Service.Document.Upload do
  use Aicacia.Handler
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Repo}
  alias Quantu.App.Web.Uploader

  @primary_key false
  schema "" do
    belongs_to(:document, Model.Document, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
    field(:url, Uploader.Document.Type)
    field(:content_hash, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:document_id, :user_id, :content_hash])
    |> cast_attachments(attrs, [:url])
    |> validate_required([:document_id, :user_id])
    |> foreign_key_constraint(:document_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Document, id: command.document_id, user_id: command.user_id)
      |> cast(command, [:url, :content_hash])
      |> Repo.update!()
    end)
  end
end
