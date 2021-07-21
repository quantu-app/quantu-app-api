defmodule Quantu.App.Model.Card do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "cards" do
    belongs_to(:deck, Model.Deck, type: :binary_id)

    field(:front, {:array, :map}, null: false, default: [])
    field(:back, {:array, :map}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
