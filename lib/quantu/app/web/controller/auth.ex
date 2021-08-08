defmodule Quantu.App.Web.Controller.Auth do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Guardian, Schema, View}

  plug Ueberauth
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["Auth"]

  operation :current,
    summary: "Gets the Current User",
    description: "Returns the current user based on the bearer token",
    responses: [
      ok: {"Current User Response", "application/json", Schema.User.Private}
    ],
    security: [%{"authorization" => []}]

  def current(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_view(View.User)
    |> render("private_show.json",
      user: Service.User.Show.get_user!(resource_user.id),
      token: Guardian.Plug.current_token(conn)
    )
  end

  operation :delete,
    summary: "Sign current User out",
    description: "Signs out the current User based on the bearer token",
    responses: [
      no_content: "Empty response"
    ],
    security: [%{"authorization" => []}]

  def delete(conn, _params) do
    with {:ok, _claims} <- Guardian.revoke(Guardian.Plug.current_token(conn)) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :callback,
    summary: "Signs in the Current User",
    description: "Returns the current user",
    responses: [
      ok: {"User Response", "application/json", Schema.User.Private}
    ],
    parameters: [
      provider: [in: :path, description: "Auth Provider", type: :string, example: "google"]
    ]

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, user} <- Service.User.FromUeberauth.from_ueberauth(auth) do
      conn = Guardian.Plug.sign_in(conn, user)

      conn
      |> put_layout({View.Layout, "app.html"})
      |> put_view(View.Auth)
      |> render("callback.html",
        user: user,
        token: Guardian.Plug.current_token(conn)
      )
    end
  end

  operation :request,
    summary: "Requests the providers context",
    description: "Returns the providers context",
    parameters: [
      provider: [in: :path, description: "Auth Provider", type: :string, example: "google"]
    ]
end
