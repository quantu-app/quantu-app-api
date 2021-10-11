defmodule Quantu.App.Web.Controller.Asset do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.{Service, Web.Uploader}
  alias Quantu.App.Web.Schema

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Asset"]

  operation :show_by_parent,
    summary: "Get an Asset",
    description: "Returns organization's asset",
    responses: [
      ok: {"Organization Asset", "*/*", Schema.Asset.File}
    ],
    parameters: [
      id: [in: :path, description: "Asset Id", type: :integer, example: 1],
      parent_id: [in: :path, description: "Asset Parent Id", type: :integer, example: 2],
      organization_id: [
        in: :path,
        description: "Asset Organization Id",
        type: :integer,
        example: 3
      ]
    ],
    security: [%{"authorization" => []}]

  def show_by_parent(conn, %{organization_id: organization_id, parent_id: parent_id, id: asset_id}) do
    with {:ok, command} <-
           Service.Asset.Show.new(%{
             asset_id: asset_id,
             parent_id: parent_id,
             organization_id: organization_id
           }),
         {:ok, asset} <- Service.Asset.Show.handle(command) do
      if Application.get_env(:waffle, :storage) == Waffle.Storage.Local do
        conn
        |> put_resp_header("content-type", asset.type)
        |> send_file(200, Uploader.Asset.local_filepath({asset.name, asset}))
      else
        conn
        |> redirect(external: Uploader.Asset.url({asset.name, asset}))
      end
    end
  end

  operation :show_by_organization,
    summary: "Get an Asset",
    description: "Returns organization's asset",
    responses: [
      ok: {"Organization Asset", "*/*", Schema.Asset.File}
    ],
    parameters: [
      id: [in: :path, description: "Asset Id", type: :integer, example: 1],
      organization_id: [
        in: :path,
        description: "Asset Organization Id",
        type: :integer,
        example: 3
      ]
    ],
    security: [%{"authorization" => []}]

  def show_by_organization(conn, %{
        organization_id: organization_id,
        id: asset_id
      }) do
    with {:ok, command} <-
           Service.Asset.Show.new(%{asset_id: asset_id, organization_id: organization_id}),
         {:ok, asset} <- Service.Asset.Show.handle(command) do
      if Application.get_env(:waffle, :storage) == Waffle.Storage.Local do
        conn
      |> put_resp_header("content-type", asset.type)
      |> send_file(200, Uploader.Asset.local_filepath({asset.name, asset}))
      else
        conn
        |> redirect(external: Uploader.Asset.url({asset.name, asset}))
      end
    end
  end
end
