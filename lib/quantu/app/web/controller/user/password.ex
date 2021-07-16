defmodule Quantu.App.Web.Controller.User.Password do
  @moduledoc tags: ["User"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, View, Guardian, Controller}

  action_fallback(Controller.Fallback)

  @doc """
  Reset Password

  Resets the User's Password creating a new Token in the process
  """
  @doc request_body:
         {"reset user password", "application/json", Schema.User.PasswordReset, required: true},
       responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ]
  def reset(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.User.Reset.new(%{
             user_id: resource_user.id,
             old_password: Map.get(params, "oldPassword"),
             password: Map.get(params, "password")
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
