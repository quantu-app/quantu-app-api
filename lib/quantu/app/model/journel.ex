defmodule Quantu.App.Model.Journel do
  use Ecto.Schema

  alias Quantu.App.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "journels" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:name, :string, null: false)
    field(:content, {:array, :map}, null: false, default: [])
    field(:language, :string, null: false, default: "en")
    field(:word_count, :integer, null: false, default: 0)
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
