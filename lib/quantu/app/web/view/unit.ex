defmodule Quantu.App.Web.View.Unit do
  use Quantu.App.Web, :view

  alias Quantu.App.Model
  alias Quantu.App.Web.View.Unit
  alias Quantu.App.Web.View.Quiz
  alias Quantu.App.Web.View.Lesson

  def render("index.json", %{units: units}),
    do: render_many(units, Unit, "unit.json")

  def render("show.json", %{unit: unit}),
    do: render_one(unit, Unit, "unit.json")

  def render("children.json", %{children: children}),
    do: render_many(children, Unit, "child.json")

  def render("unit.json", %{unit: unit}),
    do: %{
      id: unit.id,
      organizationId: unit.organization_id,
      courseId: Map.get(unit, :course_id),
      index: Map.get(unit, :index),
      published: unit.published,
      name: unit.name,
      description: unit.description,
      tags: unit.tags,
      insertedAt: unit.inserted_at,
      updatedAt: unit.updated_at
    }

  def render("child.json", %{unit: %Model.Quiz{} = child}),
    do: render_one(child, Quiz, "quiz.json")

  def render("child.json", %{unit: %Model.Lesson{} = child}),
    do: render_one(child, Lesson, "lesson.json")
end
