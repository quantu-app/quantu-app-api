defmodule Quantu.App.Web.View.Question do
  use Quantu.App.Web, :view

  alias Quantu.App.Util
  alias Quantu.App.Web.View.Question

  def render("index.json", %{questions: questions}),
    do: render_many(questions, Question, "question.json")

  def render("show.json", %{question: question}),
    do: render_one(question, Question, "question.json")

  def render("question.json", %{question: question}),
    do: %{
      id: question.id,
      organizationId: question.organization_id,
      quizId: Map.get(question, :quiz_id),
      index: Map.get(question, :index),
      type: question.type,
      prompt: Util.camelize(question.prompt),
      tags: question.tags,
      insertedAt: question.inserted_at,
      updatedAt: question.updated_at
    }
end
