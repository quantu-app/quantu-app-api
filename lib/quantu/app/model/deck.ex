defmodule Quantu.App.Model.Deck do
  use Ecto.Schema

  alias Quantu.App.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "decks" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:name, :string, null: false)
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
