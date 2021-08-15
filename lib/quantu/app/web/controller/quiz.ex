defmodule Quantu.App.Web.Controller.Quiz do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Quiz"]

  operation :index,
    summary: "List Quizzes",
    description: "Returns organization's quizzes",
    responses: [
      ok: {"Organization Quizzes", "application/json", Schema.Quiz.List}
    ],
    parameters: [
      organizationId: [
        in: :query,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Index.new(%{
             organization_id: Map.get(params, :organizationId)
           }),
         {:ok, quizzes} <- Service.Quiz.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("index.json", quizzes: quizzes)
    end
  end

  operation :show,
    summary: "Get a Quiz",
    description: "Returns organization's quiz",
    responses: [
      ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
    ],
    parameters: [
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: quiz_id}) do
    with {:ok, command} <- Service.Quiz.Show.new(%{quiz_id: quiz_id}),
         {:ok, quiz} <- Service.Quiz.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end
end
