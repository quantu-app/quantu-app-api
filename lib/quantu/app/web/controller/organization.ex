defmodule Quantu.App.Web.Controller.Organization do
  @moduledoc tags: ["Organization"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Organizations

  Returns all organizations
  """
  @doc responses: [
         ok: {"User Organizations", "application/json", Schema.Organization.List}
       ]
  def index(conn, _params) do
    with {:ok, command} <- Service.Organization.Index.new(%{}),
         {:ok, organizations} <- Service.Organization.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("index.json", organizations: organizations)
    end
  end

  @doc """
  Get a Organization

  Returns an organization
  """
  @doc responses: [
         ok: {"User Organization", "application/json", Schema.Organization.Show}
       ],
       parameters: [
         id: [in: :path, description: "Organization Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    with {:ok, command} <-
           Service.Organization.Show.new(%{
             organization_id: Map.get(params, "id")
           }),
         {:ok, organization} <- Service.Organization.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  @doc """
  Get a Organization by url

  Returns an organization by url
  """
  @doc responses: [
         ok: {"User Organization", "application/json", Schema.Organization.Show}
       ],
       parameters: [
         url: [
           in: :path,
           description: "Organization's url",
           type: :string,
           example: "my-organization"
         ]
       ]
  def show_by_url(conn, params) do
    with {:ok, command} <-
           Service.Organization.ShowByUrl.new(params),
         {:ok, organization} <- Service.Organization.ShowByUrl.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end
end
