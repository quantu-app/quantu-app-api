defmodule Quantu.App.Web.View.Quiz do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Quiz

  def render("index.json", %{quizzes: quizzes}),
    do: render_many(quizzes, Quiz, "quiz.json")

  def render("show.json", %{quiz: quiz}),
    do: render_one(quiz, Quiz, "quiz.json")

  def render("quiz.json", %{quiz: quiz}),
    do: %{
      id: quiz.id,
      organizationId: quiz.organization_id,
      name: quiz.name,
      description: quiz.description,
      tags: quiz.tags,
      insertedAt: quiz.inserted_at,
      updatedAt: quiz.updated_at
    }
end
