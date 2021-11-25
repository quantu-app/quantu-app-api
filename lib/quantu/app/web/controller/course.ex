defmodule Quantu.App.Web.Controller.Course do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Course"]

  operation :index,
    summary: "List Courses",
    description: "Returns organization's courses",
    responses: [
      ok: {"Organization Courses", "application/json", Schema.Course.List}
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
           Service.Course.Index.new(%{
             organization_id: Map.get(params, :organizationId),
             published: true
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
      id: [in: :path, description: "Course Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: course_id}) do
    with {:ok, command} <- Service.Course.Show.new(%{course_id: course_id, published: true}),
         {:ok, course} <- Service.Course.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Course)
      |> render("show.json", course: course)
    end
  end
end
