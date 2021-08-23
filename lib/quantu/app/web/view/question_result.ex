defmodule Quantu.App.Web.View.QuestionResult do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.QuestionResult

  def render("index.json", %{question_results: question_results}),
    do: render_many(question_results, QuestionResult, "question_result.json")

  def render("show.json", %{question_result: question_result}),
    do: render_one(question_result, QuestionResult, "question_result.json")

  def render("question_result.json", %{question_result: question_result}),
    do: %{
      id: question_result.id,
      questionId: question_result.question_id,
      answered: question_result.answered,
      type: question_result.type,
      prompt: question_result.prompt,
      answer: question_result.answer,
      result: question_result.result,
      insertedAt: question_result.inserted_at,
      updatedAt: question_result.updated_at
    }
end
