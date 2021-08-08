defmodule Quantu.App.Web.Controller.Question do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Question"]

  operation :index,
    summary: "List Questions",
    description: "Returns organization's questions",
    responses: [
      ok: {"Organization/Quiz Questions", "application/json", Schema.Question.List}
    ],
    parameters: [
      organizationId: [
        in: :query,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
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
           Service.Question.Index.new(%{
             organization_id: Map.get(params, "organizationId"),
             quiz_id: Map.get(params, "quizId")
           }),
         {:ok, questions} <- Service.Question.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("index.json", questions: questions)
    end
  end

  operation :show,
    summary: "Get a Question",
    description: "Returns organization's question",
    responses: [
      ok: {"Organization/Quiz Question", "application/json", Schema.Question.Show}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <- Service.Question.Show.new(%{question_id: id}),
         {:ok, question} <- Service.Question.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show.json", question: question)
    end
  end
end
