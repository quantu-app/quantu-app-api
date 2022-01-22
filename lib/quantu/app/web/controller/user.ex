defmodule Quantu.App.Web.Controller.User do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Controller, Schema, View}

  plug Ueberauth
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :show,
    summary: "Gets a User by id",
    description: "Returns the user by id",
    responses: [
      ok: {"Current User Response", "application/json", Schema.User.Public}
    ],
    parameters: [
      id: [
        in: :path,
        description: "User Id",
        type: :string,
        example: "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02"
      ]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <-
           Service.User.Show.new(%{user_id: id}),
         {:ok, user} <- Service.User.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("show.json", user: user)
    end
  end

  operation :update,
    summary: "Updates the current User",
    description: "Returns the user",
    request_body:
      {"Request body to update user", "application/json", Schema.User.Update, required: true},
    responses: [
      ok: {"Updated User Response", "application/json", Schema.User.Private}
    ],
    parameters: [],
    security: [%{"authorization" => []}]

  def update(conn = %{body_params: body_params}, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.User.Update.new(%{
             user_id: resource_user.id,
             username: Map.get(body_params, :username),
             active: Map.get(body_params, :active),
             first_name: Map.get(body_params, :firstName),
             last_name: Map.get(body_params, :lastName),
             birthday: Map.get(body_params, :birthday),
             country: Map.get(body_params, :country)
           }),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json",
        user: user,
        token: Guardian.Plug.current_token(conn)
      )
    end
  end
end
