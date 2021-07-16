defmodule Quantu.App.Model.Document do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  alias Quantu.App.Model
  alias Quantu.App.Web.Uploader

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:name, :string, null: false)
    field(:type, :string, null: false)
    field(:url, Uploader.Document.Type)
    field(:content_hash, :string)
    field(:language, :string, null: false, default: "en")
    field(:word_count, :integer, null: false, default: 0)
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
