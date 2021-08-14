defmodule Quantu.App.Web.View.Question do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Question

  def render("index_private.json", %{questions: questions}),
    do: render_many(questions, Question, "question_private.json")

  def render("show_private.json", %{question: question}),
    do: render_one(question, Question, "question_private.json")

  def render("index.json", %{questions: questions}),
    do: render_many(questions, Question, "question.json")

  def render("show.json", %{question: question}),
    do: render_one(question, Question, "question.json")

  def render("question_private.json", %{question: question}),
    do: %{
      id: question.id,
      organizationId: question.organization_id,
      quizId: Map.get(question, :quiz_id),
      index: Map.get(question, :index),
      name: question.name,
      type: question.type,
      prompt: question.prompt,
      tags: question.tags,
      insertedAt: question.inserted_at,
      updatedAt: question.updated_at
    }

  def render("question.json", %{question: question}),
    do:
      render("question_private.json", %{question: question})
      |> Map.put(:prompt, render_prompt(question.prompt))

  def render("answer.json", %{result: result}),
    do: %{result: result}

  def render_prompt(%{"front" => front, "back" => back}),
    do: %{
      front: front,
      back: back
    }

  def render_prompt(%{"question" => question, "choices" => choices}),
    do: %{
      "question" => question,
      "choices" =>
        choices
        |> Enum.reduce(%{}, fn {key, choice}, choices ->
          choices |> Map.put(key, choice |> Map.delete("correct"))
        end)
    }

  def render_prompt(prompt), do: prompt
end
