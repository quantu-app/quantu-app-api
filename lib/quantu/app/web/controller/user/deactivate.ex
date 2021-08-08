defmodule Quantu.App.Web.Controller.User.Deactivate do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, Guardian, Controller}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :deactivate,
    summary: "Deactivates the Current User",
    description: "Deactivates the current User's account",
    responses: [
      ok: {"PrivateUser", "application/json", Schema.User.Private}
    ],
    security: [%{"authorization" => []}]

  def deactivate(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.User.Deactivate.new(%{user_id: resource_user.id}),
         {:ok, user} <- Service.User.Deactivate.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
