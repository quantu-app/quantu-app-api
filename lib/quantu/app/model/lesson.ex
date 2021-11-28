defmodule Quantu.App.Model.Lesson do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "lessons" do
    belongs_to(:organization, Model.Organization)

    field(:published, :boolean, null: false, default: false)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:content, {:array, :map}, null: false, default: [])

    field(:index, :integer, virtual: true)
    field(:unit_id, :integer, virtual: true)
    field(:type, :string, virtual: true)

    timestamps(type: :utc_datetime)
  end
end
