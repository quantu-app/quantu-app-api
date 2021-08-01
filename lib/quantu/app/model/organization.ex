defmodule Quantu.App.Model.Organization do
  use Ecto.Schema

  alias Quantu.App.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:name, :string, null: false)
    field(:url, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
