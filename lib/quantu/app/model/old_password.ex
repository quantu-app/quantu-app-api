defmodule Quantu.App.Model.OldPassword do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "old_passwords" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:encrypted_password, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
