defmodule Quantu.App.Model.Course do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "courses" do
    belongs_to(:organization, Model.Organization)
    many_to_many(:units, Model.Unit, join_through: Model.CourseUnitJoin)

    field(:published, :boolean, null: false, default: false)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])

    timestamps(type: :utc_datetime)
  end
end
