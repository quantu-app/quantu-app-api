defmodule Quantu.App.Web.Controller.User.Organization do
  @moduledoc tags: ["User", "Organization"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Organizations

  Returns user's organizations
  """
  @doc responses: [
         ok: {"User Organizations", "application/json", Schema.Organization.List}
       ]
  def index(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Organization.Index.new(%{user_id: resource_user.id}),
         {:ok, organizations} <- Service.Organization.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("index.json", organizations: organizations)
    end
  end

  @doc """
  Get a Organization

  Returns user's organization
  """
  @doc responses: [
         ok: {"User Organization", "application/json", Schema.Organization.Show}
       ],
       parameters: [
         id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
       ]
  def show(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Show.new(%{
             organization_id: Map.get(params, "id"),
             user_id: resource_user.id
           }),
         {:ok, organization} <- Service.Organization.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  @doc """
  Create a Organization

  Returns user's created organization
  """
  @doc request_body:
         {"Request body to create organization", "application/json", Schema.Organization.Create,
          required: true},
       responses: [
         ok: {"User Organization", "application/json", Schema.Organization.Show}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Create.new(
             Map.merge(Util.underscore(params), %{"user_id" => resource_user.id})
           ),
         {:ok, organization} <- Service.Organization.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  @doc """
  Updates a Organization

  Returns user's updated organization
  """
  @doc request_body:
         {"Request body to update organization", "application/json", Schema.Organization.Update,
          required: true},
       responses: [
         ok: {"User Organization", "application/json", Schema.Organization.Show}
       ],
       parameters: [
         id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Update.new(
             Map.merge(Util.underscore(params), %{
               "organization_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, organization} <- Service.Organization.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  @doc """
  Delete a Organization

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
       ]
  def delete(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Delete.new(%{
             organization_id: Map.get(params, "id"),
             user_id: resource_user.id
           }),
         {:ok, _} <- Service.Organization.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
