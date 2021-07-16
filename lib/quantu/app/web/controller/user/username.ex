defmodule Quantu.App.Web.Controller.User.Username do
  @moduledoc tags: ["User"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Service
  alias Quantu.App.Web.{Controller, View, Schema, Guardian}

  action_fallback(Controller.Fallback)

  @doc """
  Update User's Username

  Updates a User's Username
  """
  @doc request_body:
         {"Update User's Username Body", "application/json", Schema.User.UsernameUpdate,
          required: true},
       responses: [
         ok: {"Update User's Username Response", "application/json", Schema.User.Private}
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.User.Update.new(%{
             user_id: resource_user.id,
             username: Map.get(params, "username")
           }),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, token: Guardian.Plug.current_token(conn))
    end
  end
end
