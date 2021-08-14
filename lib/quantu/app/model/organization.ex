defmodule Quantu.App.Model.Organization do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "organizations" do
    belongs_to(:user, Model.User, type: :binary_id)
    has_many(:questions, Model.Question)

    field(:name, :string, null: false)
    field(:url, :string, null: false)
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
