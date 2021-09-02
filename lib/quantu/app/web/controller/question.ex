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
             organization_id: Map.get(params, :organizationId),
             quiz_id: Map.get(params, :quizId)
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

  operation :answer,
    summary: "Answer a Question",
    description: "Returns correct status",
    request_body:
      {"Request body to answer question", "application/json", Schema.QuestionResult.Answer,
       required: true},
    responses: [
      ok: {"Question Answer result", "application/json", Schema.QuestionResult.Show}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def answer(
        conn = %{
          body_params: answer
        },
        %{id: id}
      ) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Answer.new(%{
             user_id: resource_user.id,
             question_id: id,
             answer: answer
           }),
         {:ok, question_result} <- Service.Question.Answer.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.QuestionResult)
      |> render("question_result.json", question_result: question_result)
    end
  end

  operation :explain,
    summary: "Explain a Question",
    description: "Returns Question result with explanation",
    responses: [
      ok: {"Question Answer result", "application/json", Schema.QuestionResult.Show}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def explain(
        conn,
        %{id: id}
      ) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Explain.new(%{
             user_id: resource_user.id,
             question_id: id
           }),
         {:ok, question_result} <- Service.Question.Explain.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.QuestionResult)
      |> render("question_result.json", question_result: question_result)
    end
  end
end
