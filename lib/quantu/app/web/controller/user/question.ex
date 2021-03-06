defmodule Quantu.App.Web.Controller.User.Question do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags(["User", "Question"])

  operation :index,
    summary: "List Questions",
    description: "Returns organization's questions",
    responses: [
      ok: {"Organization/Quiz Questions", "application/json", Schema.Question.ListPrivate}
    ],
    parameters: [
      organization_id: [
        in: :path,
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

  def index(conn, params = %{organization_id: organization_id}) do
    with {:ok, command} <-
           Service.Question.Index.new(%{
             organization_id: organization_id,
             quiz_id: Map.get(params, :quizId)
           }),
         {:ok, questions} <- Service.Question.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("index_private.json", questions: questions)
    end
  end

  operation :show,
    summary: "Get a Question",
    description: "Returns organization's question",
    responses: [
      ok: {"Organization/Quiz Question", "application/json", Schema.Question.ShowPrivate}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <- Service.Question.Show.new(%{question_id: id}),
         {:ok, question} <- Service.Question.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show_private.json", question: question)
    end
  end

  operation :create,
    summary: "Create a Question",
    description: "Returns organization's created question",
    request_body:
      {"Request body to create question", "application/json", Schema.Question.Create,
       required: true},
    responses: [
      ok: {"Organization/Quiz Question", "application/json", Schema.Question.ShowPrivate}
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

  def create(
        conn = %{body_params: body_params},
        %{organization_id: organization_id}
      ) do
    with {:ok, command} <-
           Service.Question.Create.new(%{
             organization_id: organization_id,
             quiz_id: Map.get(body_params, :quizId),
             name: body_params.name,
             type: body_params.type,
             prompt: body_params.prompt,
             tags: body_params.tags,
             index: Map.get(body_params, :index),
             is_challenge: body_params.isChallenge,
             released_at: body_params.releasedAt
           }),
         {:ok, question} <- Service.Question.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Question)
      |> render("show_private.json", question: question)
    end
  end

  operation :update,
    summary: "Updates a Question",
    description: "Returns organization's updated question",
    request_body:
      {"Request body to update question", "application/json", Schema.Question.Update,
       required: true},
    responses: [
      ok: {"Organization/Quiz Question", "application/json", Schema.Question.ShowPrivate}
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001],
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
           Service.Question.Update.new(%{
             quiz_id: Map.get(body_params, :quizId),
             name: Map.get(body_params, :name),
             type: Map.get(body_params, :type),
             prompt: Map.get(body_params, :prompt),
             tags: Map.get(body_params, :tags),
             index: Map.get(body_params, :index),
             is_challenge: Map.get(body_params, :isChallenge),
             released_at: Map.get(body_params, :releasedAt),
             question_id: id
           }),
         {:ok, question} <- Service.Question.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show_private.json", question: question)
    end
  end

  operation :delete,
    summary: "Delete a Question",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Question Id", type: :integer, example: 1001],
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
           Service.Question.Delete.new(%{
             question_id: id
           }),
         {:ok, _} <- Service.Question.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
