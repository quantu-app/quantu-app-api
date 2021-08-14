defmodule Quantu.App.Web.Controller.User.Organization do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["User", "Organization"]

  operation :index,
    summary: "List Organizations",
    description: "Returns user's organizations",
    responses: [
      ok: {"User Organizations", "application/json", Schema.Organization.List}
    ],
    security: [%{"authorization" => []}]

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

  operation :show,
    summary: "Get a Organization",
    description: "Returns user's organization",
    responses: [
      ok: {"User Organization", "application/json", Schema.Organization.Show}
    ],
    parameters: [
      id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Show.new(%{
             organization_id: id,
             user_id: resource_user.id
           }),
         {:ok, organization} <- Service.Organization.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  operation :create,
    summary: "Create a Organization",
    description: "Returns user's created organization",
    request_body:
      {"Request body to create organization", "application/json", Schema.Organization.Create,
       required: true},
    responses: [
      ok: {"User Organization", "application/json", Schema.Organization.Show}
    ],
    security: [%{"authorization" => []}]

  def create(
        conn = %{
          body_params: body_params
        },
        _params
      ) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Create.new(%{
             name: body_params.name,
             url: body_params.url,
             tags: body_params.tags,
             user_id: resource_user.id
           }),
         {:ok, organization} <- Service.Organization.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  operation :update,
    summary: "Updates a Organization",
    description: "Returns user's updated organization",
    request_body:
      {"Request body to update organization", "application/json", Schema.Organization.Update,
       required: true},
    responses: [
      ok: {"User Organization", "application/json", Schema.Organization.Show}
    ],
    parameters: [
      id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def update(
        conn = %{
          body_params: body_params
        },
        %{id: id}
      ) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Update.new(%{
             name: body_params.name,
             url: body_params.url,
             tags: body_params.tags,
             organization_id: id,
             user_id: resource_user.id
           }),
         {:ok, organization} <- Service.Organization.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Organization)
      |> render("show.json", organization: organization)
    end
  end

  operation :delete,
    summary: "Delete a Organization",
    description: "Returns nothing",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Organization Id", type: :integer, example: 1001]
    ],
    security: [%{"authorization" => []}]

  def delete(conn, %{id: id}) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Organization.Delete.new(%{
             organization_id: id,
             user_id: resource_user.id
           }),
         {:ok, _} <- Service.Organization.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
