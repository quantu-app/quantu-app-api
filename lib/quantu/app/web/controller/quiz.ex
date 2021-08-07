defmodule Quantu.App.Web.Controller.Quiz do
  @moduledoc tags: ["Quiz"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
    alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Quizzes

  Returns organization's quizzes
  """
  @doc responses: [
         ok: {"Organization Quizzes", "application/json", Schema.Quiz.List}
       ],
       parameters: [
         organizationId: [
           in: :query,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def index(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Index.new(%{
             organization_id: Map.get(params, "organizationId")
           }),
         {:ok, quizzes} <- Service.Quiz.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("index.json", quizzes: quizzes)
    end
  end

  @doc """
  Get a Quiz

  Returns organization's quiz
  """
  @doc responses: [
         ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
       ],
       parameters: [
         id: [in: :path, description: "Quiz Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    with {:ok, command} <- Service.Quiz.Show.new(%{quiz_id: Map.get(params, "id")}),
         {:ok, quiz} <- Service.Quiz.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end
end
