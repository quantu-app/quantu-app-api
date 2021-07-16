defmodule Quantu.App.Web.Controller.User.Deactivate do
  @moduledoc tags: ["User"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, Guardian, Controller}

  action_fallback(Controller.Fallback)

  @doc """
  Deactivates the Current User

  Deactivates the current User's account
  """
  @doc responses: [
         ok: {"PrivateUser", "application/json", Schema.User.Private}
       ]
  def delete(conn, _params) do
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
