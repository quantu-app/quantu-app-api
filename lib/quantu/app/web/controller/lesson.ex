defmodule Quantu.App.Web.Controller.Lesson do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Lesson"]

  operation :index,
    summary: "List Lessons",
    description: "Returns organization's lessons",
    responses: [
      ok: {"Organization Lessons", "application/json", Schema.Lesson.List}
    ],
    parameters: [
      organizationId: [
        in: :query,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
      unitId: [
        in: :query,
        description: "Unit Id",
        type: :integer,
        example: 1002
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, params) do
    with {:ok, command} <-
           Service.Lesson.Index.new(%{
             organization_id: Map.get(params, :organizationId),
             unit_id: Map.get(params, :unitId),
             published: true
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
      id: [in: :path, description: "Lesson Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: lesson_id}) do
    with {:ok, command} <- Service.Lesson.Show.new(%{lesson_id: lesson_id, published: true}),
         {:ok, lesson} <- Service.Lesson.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Lesson)
      |> render("show.json", lesson: lesson)
    end
  end
end
