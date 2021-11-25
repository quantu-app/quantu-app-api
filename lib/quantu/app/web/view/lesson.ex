defmodule Quantu.App.Web.View.Lesson do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Lesson

  def render("index.json", %{lessons: lessons}),
    do: render_many(lessons, Lesson, "lesson.json")

  def render("show.json", %{lesson: lesson}),
    do: render_one(lesson, Lesson, "lesson.json")

  def render("lesson.json", %{lesson: lesson}),
    do: %{
      id: lesson.id,
      organizationId: lesson.organization_id,
      unitId: Map.get(lesson, :unit_id),
      index: Map.get(lesson, :index),
      published: lesson.published,
      name: lesson.name,
      description: lesson.description,
      tags: lesson.tags,
      content: lesson.content,
      insertedAt: lesson.inserted_at,
      updatedAt: lesson.updated_at
    }
end
