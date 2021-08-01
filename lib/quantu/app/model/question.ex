defmodule Quantu.App.Model.Question do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "questions" do
    belongs_to(:organization, Model.Organization, type: :binary_id)

    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
