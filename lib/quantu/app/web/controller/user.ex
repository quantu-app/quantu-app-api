defmodule Quantu.App.Web.Controller.User do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Controller, Schema, View}

  plug Ueberauth
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :show,
    summary: "Gets a User by id",
    description: "Returns the user by id",
    responses: [
      ok: {"Current User Response", "application/json", Schema.User.Public}
    ],
    parameters: [
      id: [
        in: :path,
        description: "User Id",
        type: :string,
        example: "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02"
      ]
    ],
    security: [%{"authorization" => []}]

  def show(conn, %{id: id}) do
    with {:ok, command} <-
           Service.User.Show.new(%{user_id: id}),
         {:ok, user} <- Service.User.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("show.json", user: user)
    end
  end
end
