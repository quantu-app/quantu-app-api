defmodule Quantu.App.Web.Controller.Auth.SignUp do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View, Guardian}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Auth"]

  operation :sign_up,
    summary: "Signs up a user and returns the User with the Bearer Token",
    request_body:
      {"Request body to sign up", "application/json", Schema.SignUp.UsernamePassword,
       required: true},
    responses: [
      ok: {"Sign up User Response", "application/json", Schema.User.Private}
    ]

  def sign_up(conn = %{body_params: body_params}, _params) do
    with {:ok, command} <-
           Service.User.Create.new(%{
             username: body_params.username,
             password: body_params.password,
             password_confirmation: body_params.passwordConfirmation
           }),
         {:ok, user} <- Service.User.Create.handle(command) do
      conn = Guardian.Plug.sign_in(conn, user)

      conn
      |> put_status(201)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
