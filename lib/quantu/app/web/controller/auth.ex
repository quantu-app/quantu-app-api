defmodule Quantu.App.Web.Controller.Auth do
  @moduledoc tags: ["Auth"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller
  plug(Ueberauth)

  alias Quantu.App.Service
  alias Quantu.App.Web.{Guardian, Schema, View}

  action_fallback(Controller.Fallback)

  @doc """
  Gets the Current User

  Returns the current user based on the bearer token
  """
  @doc responses: [
         ok: {"Current User Response", "application/json", Schema.User.Private}
       ]
  def current(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_view(View.User)
    |> render("private_show.json",
      user: Service.User.Show.get_user!(resource_user.id),
      token: Guardian.Plug.current_token(conn)
    )
  end

  @doc """
  Sign current User out

  Signs out the current User based on the bearer token
  """
  @doc responses: [
         no_content: "Empty response"
       ]
  def delete(conn, _params) do
    with {:ok, _claims} <- Guardian.revoke(Guardian.Plug.current_token(conn)) do
      send_resp(conn, :no_content, "")
    end
  end
end
