defmodule Quantu.App.Web.Controller.User.Quiz do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Quiz"]

  operation :index,
    summary: "List Quizzes",
    description: "Returns organization's quizzes",
    responses: [
      ok: {"Organization Quizzes", "application/json", Schema.Quiz.List}
    ],
    parameters: [
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, %{organization_id: organization_id}) do
    with {:ok, command} <-
           Service.Quiz.Index.new(%{
             organization_id: organization_id
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
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{organization_id: organization_id, id: id}) do
    with {:ok, command} <-
           Service.Quiz.Show.new(%{
             quiz_id: id,
             organization_id: organization_id
           }),
         {:ok, quiz} <- Service.Quiz.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  operation :create,
    summary: "Create a Quiz",
    description: "Returns organization's created quiz",
    request_body:
      {"Request body to create quiz", "application/json", Schema.Quiz.Create, required: true},
    responses: [
      ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
    ],
    parameters: [
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def create(conn = %{body_params: body_params}, %{organization_id: organization_id}) do
    with {:ok, command} <-
           Service.Quiz.Create.new(%{
             organization_id: organization_id,
             name: body_params.name,
             description: Map.get(body_params, :description),
             tags: Map.get(body_params, :tags)
           }),
         {:ok, quiz} <- Service.Quiz.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  operation :update,
    summary: "Updates a Quiz",
    description: "Returns organization's updated quiz",
    request_body:
      {"Request body to update quiz", "application/json", Schema.Quiz.Update, required: true},
    responses: [
      ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
    ],
    parameters: [
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def update(conn = %{body_params: body_params}, %{id: id}) do
    with {:ok, command} <-
           Service.Quiz.Update.new(%{
             quiz_id: id,
             name: body_params.name,
             description: body_params.description,
             tags: body_params.tags
           }),
         {:ok, quiz} <- Service.Quiz.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  operation :delete,
    summary: "Delete a Quiz",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def delete(conn, %{id: id}) do
    with {:ok, command} <-
           Service.Quiz.Delete.new(%{
             quiz_id: id
           }),
         {:ok, _} <- Service.Quiz.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :add_questions,
    summary: "Add Quertions to Quiz",
    description: "Returns nothing",
    request_body:
      {"Request body to add questions to quiz", "application/json", Schema.Quiz.QuestionIds,
       required: true},
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def add_questions(conn = %{body_params: body_params}, %{id: id}) do
    with {:ok, command} <-
           Service.Quiz.AddQuestions.new(%{
             quiz_id: id,
             questions: body_params.questions
           }),
         {:ok, _} <- Service.Quiz.AddQuestions.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :remove_questions,
    summary: "Remove Quertions from Quiz",
    description: "Returns nothing",
    request_body:
      {"Request body to remove questions from quiz", "application/json", Schema.Quiz.QuestionIds,
       required: true},
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Quiz Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def remove_questions(conn = %{body_params: body_params}, %{id: id}) do
    with {:ok, command} <-
           Service.Quiz.RemoveQuestions.new(%{
             quiz_id: id,
             questions: body_params.questions
           }),
         {:ok, _} <- Service.Quiz.RemoveQuestions.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
