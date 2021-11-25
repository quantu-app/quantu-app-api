defmodule Quantu.App.Web.Controller.Unit do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Unit"]

  operation :index,
    summary: "List Units",
    description: "Returns organization's units",
    responses: [
      ok: {"Organization Units", "application/json", Schema.Unit.List}
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
           Service.Unit.Index.new(%{
             organization_id: Map.get(params, :organizationId),
             unit_id: Map.get(params, :unitId),
             published: true
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
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: unit_id}) do
    with {:ok, command} <- Service.Unit.Show.new(%{unit_id: unit_id, published: true}),
         {:ok, unit} <- Service.Unit.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("show.json", unit: unit)
    end
  end

  operation :children,
    summary: "Get a Unit's children",
    description: "Returns organization's unit's children",
    responses: [
      ok: {"Organization Unit", "application/json", Schema.Unit.ChildList}
    ],
    parameters: [
      id: [in: :path, description: "Unit Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def children(conn, %{id: unit_id}) do
    with {:ok, command} <- Service.Unit.Show.new(%{unit_id: unit_id, published: true}),
         {:ok, unit} <- Service.Unit.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Unit)
      |> render("children.json", children: Service.Unit.Show.unit_children(unit))
    end
  end
end
