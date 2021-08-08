defmodule Quantu.App.Web.Controller.User.Password do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View, Guardian, Controller}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :reset,
    summary: "Reset Password",
    description: "Resets the User's Password creating a new Token in the process",
    request_body:
      {"reset user password", "application/json", Schema.User.PasswordReset, required: true},
    responses: [
      ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
    ],
    security: [%{"authorization" => []}]

  def reset(
        conn = %{
          body_params: body_params
        },
        _params
      ) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.User.Reset.new(%{
             user_id: resource_user.id,
             old_password: body_params.oldPassword,
             password: body_params.password
           }),
         {:ok, _password} <- Service.User.Reset.handle(command),
         {:ok, _claims} <- Guardian.revoke(Guardian.Plug.current_token(conn)) do
      conn = Guardian.Plug.sign_in(conn, resource_user)

      conn
      |> put_status(201)
      |> put_view(View.User)
      |> render("private_show.json",
        user: Service.User.Show.get_user!(resource_user.id),
        token: Guardian.Plug.current_token(conn)
      )
    end
  end
end
