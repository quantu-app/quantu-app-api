defmodule Quantu.App.Web.Controller.User.Unit do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Unit"]

  operation :index,
    summary: "List Units",
    description: "Returns organization's units",
    responses: [
      ok: {"Organization Units", "application/json", Schema.Unit.List}
    ],
    parameters: [
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
      courseId: [
        in: :query,
        description: "Unit Course Id",
        type: :integer,
        example: 123
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, %{organization_id: organization_id} = params) do
    with {:ok, command} <-
           Service.Unit.Index.new(%{
             organization_id: organization_id,
             course_id: Map.get(params, :courseId)
           }),
         {:ok, units} <- Service.Unit.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("index.json", units: units)
    end
  end

  operation :show,
    summary: "Get a Unit",
    description: "Returns organization's unit",
    responses: [
      ok: {"Organization Unit", "application/json", Schema.Unit.Show}
    ],
    parameters: [
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001],
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
           Service.Unit.Show.new(%{
             unit_id: id,
             organization_id: organization_id
           }),
         {:ok, unit} <- Service.Unit.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("show.json", unit: unit)
    end
  end

  operation :create,
    summary: "Create a Unit",
    description: "Returns organization's created unit",
    request_body:
      {"Request body to create unit", "application/json", Schema.Unit.Create, required: true},
    responses: [
      ok: {"Organization Unit", "application/json", Schema.Unit.Show}
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
           Service.Unit.Create.new(%{
             organization_id: organization_id,
             name: body_params.name,
             description: Map.get(body_params, :description),
             tags: Map.get(body_params, :tags),
             published: Map.get(body_params, :published),
             course_id: Map.get(body_params, :courseId),
             index: Map.get(body_params, :index)
           }),
         {:ok, unit} <- Service.Unit.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Unit)
      |> render("show.json", unit: unit)
    end
  end

  operation :update,
    summary: "Updates a Unit",
    description: "Returns organization's updated unit",
    request_body:
      {"Request body to update unit", "application/json", Schema.Unit.Update, required: true},
    responses: [
      ok: {"Organization Unit", "application/json", Schema.Unit.Show}
    ],
    parameters: [
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001],
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
           Service.Unit.Update.new(%{
             unit_id: id,
             name: body_params.name,
             description: body_params.description,
             tags: body_params.tags,
             published: Map.get(body_params, :published),
             course_id: Map.get(body_params, :courseId),
             index: Map.get(body_params, :index)
           }),
         {:ok, unit} <- Service.Unit.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("show.json", unit: unit)
    end
  end

  operation :delete,
    summary: "Delete a Unit",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001],
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
           Service.Unit.Delete.new(%{
             unit_id: id
           }),
         {:ok, _} <- Service.Unit.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :children,
    summary: "Get a Unit's children",
    description: "Returns organization's unit's children",
    responses: [
      ok: {"Organization Unit", "application/json", Schema.Unit.ChildList}
    ],
    parameters: [
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def children(conn, %{id: unit_id}) do
    with {:ok, command} <- Service.Unit.Show.new(%{unit_id: unit_id}),
         {:ok, unit} <- Service.Unit.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("children.json", children: Service.Unit.Show.unit_children(unit))
    end
  end
end
