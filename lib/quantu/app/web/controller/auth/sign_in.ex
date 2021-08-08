defmodule Quantu.App.Web.Controller.Auth.SignIn do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View, Guardian}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Auth"]

  operation :sign_in,
    summary: "Signs in user and returns the User with the Bearer Token",
    request_body:
      {"Request body to sign in", "application/json", Schema.SignIn.UsernameOrEmailAndPassword,
       required: true},
    responses: [
      ok: {"Sign in User Response", "application/json", Schema.User.Private}
    ]

  def sign_in(conn = %{body_params: body_params}, _params) do
    with {:ok, command} <-
           Service.User.ShowWithUsernameOrEmailAndPassword.new(%{
              username_or_email: body_params.usernameOrEmail,
             password: body_params.password,
           }),
         {:ok, user} <- Service.User.ShowWithUsernameOrEmailAndPassword.handle(command) do
      conn = Guardian.Plug.sign_in(conn, user)

      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
