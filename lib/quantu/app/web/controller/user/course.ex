defmodule Quantu.App.Web.Controller.User.Course do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Course"]

  operation :index,
    summary: "List Courses",
    description: "Returns organization's courses",
    responses: [
      ok: {"Organization Courses", "application/json", Schema.Course.List}
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
           Service.Course.Index.new(%{
             organization_id: organization_id
           }),
         {:ok, courses} <- Service.Course.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Course)
      |> render("index.json", courses: courses)
    end
  end

  operation :show,
    summary: "Get a Course",
    description: "Returns organization's course",
    responses: [
      ok: {"Organization Course", "application/json", Schema.Course.Show}
    ],
    parameters: [
      id: [in: :path, description: "Course Id", type: :integer, example: 1001],
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
           Service.Course.Show.new(%{
             course_id: id,
             organization_id: organization_id
           }),
         {:ok, course} <- Service.Course.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Course)
      |> render("show.json", course: course)
    end
  end

  operation :create,
    summary: "Create a Course",
    description: "Returns organization's created course",
    request_body:
      {"Request body to create course", "application/json", Schema.Course.Create, required: true},
    responses: [
      ok: {"Organization Course", "application/json", Schema.Course.Show}
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
           Service.Course.Create.new(%{
             organization_id: organization_id,
             name: body_params.name,
             description: Map.get(body_params, :description),
             tags: Map.get(body_params, :tags),
             published: Map.get(body_params, :published)
           }),
         {:ok, course} <- Service.Course.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Course)
      |> render("show.json", course: course)
    end
  end

  operation :update,
    summary: "Updates a Course",
    description: "Returns organization's updated course",
    request_body:
      {"Request body to update course", "application/json", Schema.Course.Update, required: true},
    responses: [
      ok: {"Organization Course", "application/json", Schema.Course.Show}
    ],
    parameters: [
      id: [in: :path, description: "Course Id", type: :integer, example: 1001],
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
           Service.Course.Update.new(%{
             course_id: id,
             name: body_params.name,
             description: body_params.description,
             tags: body_params.tags,
             published: Map.get(body_params, :published)
           }),
         {:ok, course} <- Service.Course.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Course)
      |> render("show.json", course: course)
    end
  end

  operation :delete,
    summary: "Delete a Course",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Course Id", type: :integer, example: 1001],
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
           Service.Course.Delete.new(%{
             course_id: id
           }),
         {:ok, _} <- Service.Course.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
