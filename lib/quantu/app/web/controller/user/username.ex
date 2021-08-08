defmodule Quantu.App.Web.Controller.User.Username do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Controller, View, Schema, Guardian}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :update,
    summary: "Update User's Username",
    description: "Updates a User's Username",
    request_body:
      {"Update User's Username Body", "application/json", Schema.User.UsernameUpdate,
       required: true},
    responses: [
      ok: {"Update User's Username Response", "application/json", Schema.User.Private}
    ],
    security: [%{"authorization" => []}]

  def update(conn = %{body_params: body_params}, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.User.Update.new(%{
             user_id: resource_user.id,
             username: body_params.username
           }),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
