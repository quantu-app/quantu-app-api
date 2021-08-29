defmodule Quantu.App.Web.Controller.QuestionResult do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Question", "Quiz", "Result"]

  operation :index,
    summary: "List Quiz Question's Results",
    description: "Returns organization's questions",
    responses: [
      ok: {"Quiz Question Results", "application/json", Schema.QuestionResult.List}
    ],
    parameters: [
      quizId: [
        in: :query,
        description: "Quiz Id",
        type: :integer,
        example: 123
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, params) do
    with {:ok, command} <-
           Service.QuestionResult.Index.new(%{
             quiz_id: Map.get(params, :quizId)
           }),
         {:ok, question_results} <- Service.QuestionResult.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.QuestionResult)
      |> render("index.json", question_results: question_results)
    end
  end

  operation :show,
    summary: "Get a Question's Result",
    description: "Returns question's result",
    responses: [
      ok: {"Organization/Quiz Question", "application/json", Schema.QuestionResult.Show}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <- Service.QuestionResult.Show.new(%{question_id: id}),
         {:ok, question_result} <- Service.QuestionResult.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.QuestionResult)
      |> render("show.json", question_result: question_result)
    end
  end
end
