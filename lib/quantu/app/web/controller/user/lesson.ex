defmodule Quantu.App.Web.Controller.User.Lesson do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Lesson"]

  operation :index,
    summary: "List Lessons",
    description: "Returns organization's lessons",
    responses: [
      ok: {"Organization Lessons", "application/json", Schema.Lesson.List}
    ],
    parameters: [
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
      unitId: [
        in: :query,
        description: "Lesson Unit Id",
        type: :integer,
        example: 123
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, %{organization_id: organization_id} = params) do
    with {:ok, command} <-
           Service.Lesson.Index.new(%{
             organization_id: organization_id,
             unit_id: Map.get(params, :unitId)
           }),
         {:ok, lessons} <- Service.Lesson.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Lesson)
      |> render("index.json", lessons: lessons)
    end
  end

  operation :show,
    summary: "Get a Lesson",
    description: "Returns organization's lesson",
    responses: [
      ok: {"Organization Lesson", "application/json", Schema.Lesson.Show}
    ],
    parameters: [
      id: [in: :path, description: "Lesson Id", type: :integer, example: 1001],
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
           Service.Lesson.Show.new(%{
             lesson_id: id,
             organization_id: organization_id
           }),
         {:ok, lesson} <- Service.Lesson.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Lesson)
      |> render("show.json", lesson: lesson)
    end
  end

  operation :create,
    summary: "Create a Lesson",
    description: "Returns organization's created lesson",
    request_body:
      {"Request body to create lesson", "application/json", Schema.Lesson.Create, required: true},
    responses: [
      ok: {"Organization Lesson", "application/json", Schema.Lesson.Show}
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
           Service.Lesson.Create.new(%{
             organization_id: organization_id,
             name: body_params.name,
             description: Map.get(body_params, :description),
             tags: Map.get(body_params, :tags),
             published: Map.get(body_params, :published),
             content: Map.get(body_params, :content),
             unit_id: Map.get(body_params, :unitId),
             index: Map.get(body_params, :index)
           }),
         {:ok, lesson} <- Service.Lesson.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Lesson)
      |> render("show.json", lesson: lesson)
    end
  end

  operation :update,
    summary: "Updates a Lesson",
    description: "Returns organization's updated lesson",
    request_body:
      {"Request body to update lesson", "application/json", Schema.Lesson.Update, required: true},
    responses: [
      ok: {"Organization Lesson", "application/json", Schema.Lesson.Show}
    ],
    parameters: [
      id: [in: :path, description: "Lesson Id", type: :integer, example: 1001],
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
           Service.Lesson.Update.new(%{
             lesson_id: id,
             name: body_params.name,
             description: body_params.description,
             tags: body_params.tags,
             published: Map.get(body_params, :published),
             content: Map.get(body_params, :content),
             unit_id: Map.get(body_params, :unitId),
             index: Map.get(body_params, :index)
           }),
         {:ok, lesson} <- Service.Lesson.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Lesson)
      |> render("show.json", lesson: lesson)
    end
  end

  operation :delete,
    summary: "Delete a Lesson",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Lesson Id", type: :integer, example: 1001],
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
           Service.Lesson.Delete.new(%{
             lesson_id: id
           }),
         {:ok, _} <- Service.Lesson.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
