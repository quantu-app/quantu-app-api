defmodule Quantu.App.Web.View.Course do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Course

  def render("index.json", %{courses: courses}),
    do: render_many(courses, Course, "course.json")

  def render("show.json", %{course: course}),
    do: render_one(course, Course, "course.json")

  def render("course.json", %{course: course}),
    do: %{
      id: course.id,
      organizationId: course.organization_id,
      published: course.published,
      name: course.name,
      description: course.description,
      tags: course.tags,
      insertedAt: course.inserted_at,
      updatedAt: course.updated_at
    }
end
