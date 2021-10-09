defmodule Quantu.App.Web.Controller.User.Asset do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Asset"]

  operation :index,
    summary: "List Assets",
    description: "Returns organization's assets",
    responses: [
      ok: {"Organization Assetzes", "application/json", Schema.Asset.List}
    ],
    parameters: [
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
      parentId: [
        in: :query,
        description: "Parent Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def index(conn, params = %{organization_id: organization_id}) do
    with {:ok, command} <-
           Service.Asset.Index.new(%{
             organization_id: organization_id,
             parent_id: Map.get(params, :parentId)
           }),
         {:ok, assets} <- Service.Asset.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Asset)
      |> render("index.json", assets: assets)
    end
  end

  operation :show,
    summary: "Get a Asset",
    description: "Returns organization's asset",
    responses: [
      ok: {"Organization Asset", "application/json", Schema.Asset.Show}
    ],
    parameters: [
      id: [in: :path, description: "Asset Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ],
      parentId: [
        in: :query,
        description: "Parent Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def show(conn, params = %{organization_id: organization_id, id: id}) do
    with {:ok, command} <-
           Service.Asset.Show.new(%{
             asset_id: id,
             organization_id: organization_id,
             parent_id: Map.get(params, :parentId)
           }),
         {:ok, asset} <- Service.Asset.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Asset)
      |> render("show.json", asset: asset)
    end
  end

  operation :create,
    summary: "Create a Asset",
    description: "Returns organization's created asset",
    request_body:
      {"Request body to create asset", "multipart/form-data", Schema.Asset.Create, required: true},
    responses: [
      ok: {"Organization Asset", "application/json", Schema.Asset.Show}
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
           Service.Asset.Create.new(%{
             organization_id: organization_id,
             parent_id: Map.get(body_params, :parentId),
             name: Map.get(body_params, :name),
             type: Map.get(body_params, :type)
           }),
         {:ok, asset} <- Service.Asset.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Asset)
      |> render("show.json", asset: asset)
    end
  end

  operation :update,
    summary: "Updates a Asset",
    description: "Returns organization's updated asset",
    request_body:
      {"Request body to update asset", "multipart/form-data", Schema.Asset.Update, required: true},
    responses: [
      ok: {"Organization Asset", "application/json", Schema.Asset.Show}
    ],
    parameters: [
      id: [in: :path, description: "Asset Id", type: :integer, example: 1001],
      organization_id: [
        in: :path,
        description: "Organization Id",
        type: :integer,
        example: 1001
      ]
    ],
    security: [%{"authorization" => []}]

  def update(conn = %{body_params: body_params}, %{id: id, organization_id: organization_id}) do
    with {:ok, command} <-
           Service.Asset.Update.new(%{
             asset_id: id,
             organization_id: organization_id,
             parent_id: Map.get(body_params, :parentId),
             name: Map.get(body_params, :name)
           }),
         {:ok, asset} <- Service.Asset.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Asset)
      |> render("show.json", asset: asset)
    end
  end

  operation :delete,
    summary: "Delete a Asset",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Asset Id", type: :integer, example: 1001],
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
           Service.Asset.Delete.new(%{
             asset_id: id
           }),
         {:ok, _} <- Service.Asset.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
