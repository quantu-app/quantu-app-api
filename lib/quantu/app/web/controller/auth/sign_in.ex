defmodule Quantu.App.Web.Controller.Auth.SignIn do
  @moduledoc tags: ["Auth"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View, Guardian}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  Sign in

  Signs in user and returns the User with the Bearer Token
  """
  @doc request_body:
         {"Request body to sign in", "application/json", Schema.SignIn.UsernameOrEmailAndPassword,
          required: true},
       responses: [
         ok: {"Sign in User Response", "application/json", Schema.User.Private}
       ]
  def sign_in(conn, params) do
    with {:ok, command} <-
           Service.User.ShowWithUsernameOrEmailAndPassword.new(Util.underscore(params)),
         {:ok, user} <- Service.User.ShowWithUsernameOrEmailAndPassword.handle(command) do
      conn = Guardian.Plug.sign_in(conn, user)

      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
