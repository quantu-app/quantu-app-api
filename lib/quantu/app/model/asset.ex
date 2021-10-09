defmodule Quantu.App.Model.Asset do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Web.Uploader}

  schema "assets" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:parent, Model.Asset)

    field(:name, Uploader.Asset.Type, null: true)
    field(:type, :string, null: true)

    timestamps(type: :utc_datetime)
  end
end
