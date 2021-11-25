defmodule Quantu.App.Model.CourseUnitJoin do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "course_unit_joins" do
    belongs_to(:course, Model.Course)
    belongs_to(:unit, Model.Unit)

    field(:index, :integer, null: false)
  end
end
