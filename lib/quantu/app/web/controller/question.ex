defmodule Quantu.App.Web.Controller.Question do
  @moduledoc tags: ["Question"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Questions

  Returns organization's questions
  """
  @doc responses: [
         ok: {"Organization/Quiz Questions", "application/json", Schema.Question.List}
       ],
       parameters: [
         organization_id: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ],
         quiz_id: [
           in: :query,
           description: "Quiz Id",
           type: :string,
           example: 123
         ]
       ]
  def index(conn, params) do
    with {:ok, command} <-
           Service.Question.Index.new(%{
             organization_id: Map.get(params, "organization_id"),
             quiz_id: Map.get(params, "quiz_id")
           }),
         {:ok, questions} <- Service.Question.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("index.json", questions: questions)
    end
  end

  @doc """
  Get a Question

  Returns organization's question
  """
  @doc responses: [
         ok: {"Organization/Quiz Question", "application/json", Schema.Question.Show}
       ],
       parameters: [
         id: [in: :path, description: "Question Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    with {:ok, command} <- Service.Question.Show.new(%{question_id: Map.get(params, "id")}),
         {:ok, question} <- Service.Question.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show.json", question: question)
    end
  end
end
