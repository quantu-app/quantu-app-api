defmodule Quantu.App.Web.Controller.Auth.SignUp do
  @moduledoc tags: ["Auth"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View, Guardian}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  Sign up

  Signs up a user and returns the User with the Bearer Token
  """
  @doc request_body:
         {"Request body to sign up", "application/json", Schema.SignUp.UsernamePassword,
          required: true},
       responses: [
         ok: {"Sign up User Response", "application/json", Schema.User.Private}
       ]
  def sign_up(conn, params) do
    with {:ok, command} <- Service.User.Create.new(Util.underscore(params)),
         {:ok, user} <- Service.User.Create.handle(command) do
      conn = Guardian.Plug.sign_in(conn, user)

      conn
      |> put_status(201)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
