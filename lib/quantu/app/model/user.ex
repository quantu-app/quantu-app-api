defmodule Quantu.App.Model.User do
  use Ecto.Schema

  alias Quantu.App.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_many(:emails, Model.Email)
    has_many(:old_passwords, Model.OldPassword)

    field(:encrypted_password, :string, null: false)
    field(:username, :string, null: false)
    field(:active, :boolean, null: false, default: true)

    timestamps(type: :utc_datetime)
  end
end
