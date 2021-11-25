defmodule Quantu.App.Model.UnitChildJoin do
  use Ecto.Schema

  alias Quantu.App.Model

  schema "unit_child_joins" do
    belongs_to(:unit, Model.Unit)
    belongs_to(:quiz, Model.Quiz)
    belongs_to(:lesson, Model.Lesson)

    field(:index, :integer, null: false)
  end
end
