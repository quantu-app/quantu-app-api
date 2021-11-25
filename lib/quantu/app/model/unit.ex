defmodule Quantu.App.Model.Unit do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "units" do
    belongs_to(:organization, Model.Organization)

    field(:published, :boolean, null: false, default: false)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
