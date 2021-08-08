defmodule Quantu.App.Web.Controller.Organization do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Organization"]

  operation :index,
    summary: "List Organizations",
    description: "Returns all organizations",
    responses: [
      ok: {"User Organizations", "application/json", Schema.Organization.List}
    ],
    security: [%{"authorization" => []}]

  def index(conn, _params) do
    with {:ok, command} <- Service.Organization.Index.new(%{}),
         {:ok, organizations} <- Service.Organization.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("index.json", organizations: organizations)
    end
  end

  operation :show,
    summary: "Get a Organization",
    description: "Returns an organization",
    responses: [
      ok: {"User Organization", "application/json", Schema.Organization.Show}
    ],
    parameters: [
      id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <-
           Service.Organization.Show.new(%{
             organization_id: id
           }),
         {:ok, organization} <- Service.Organization.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  operation :show_by_url,
    summary: "Get a Organization by url",
    description: "Returns an organization by url",
    responses: [
      ok: {"User Organization", "application/json", Schema.Organization.Show}
    ],
    parameters: [
      url: [
        in: :path,
        description: "Organization's url",
        type: :string,
        example: "my-organization"
      ]
    ],
    security: [%{"authorization" => []}]

  def show_by_url(conn, %{url: url}) do
    with {:ok, command} <-
           Service.Organization.ShowByUrl.new(%{url: url}),
         {:ok, organization} <- Service.Organization.ShowByUrl.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end
end
