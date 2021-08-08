defmodule Quantu.App.Web.Controller.User.Email do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Service
  alias Quantu.App.Web.{Schema, Controller, View, Guardian}

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Controller.Fallback)

  tags ["User"]

  operation :confirm,
    summary: "Confirm an Eamil",
    description: "Confirms an Email and returns the User with the Bearer Token",
    responses: [
      ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
    ],
    parameters: [
      confirmationToken: [
        in: :query,
        description: "Confirmation Token",
        type: :string,
        required: true,
        example: "qID3Z0xsVeDouJNjnKk5OxM9HsCtyY0gDJyU5bF2SjaBPjpkfqKBiim2W9v6nK"
      ]
    ],
    security: [%{"authorization" => []}]

  def confirm(conn, %{confirmationToken: confirmationToken}) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.Confirm.new(%{
             confirmation_token: confirmationToken
           }),
         {:ok, _email} <- Service.Email.Confirm.handle(command) do
      conn
      |> put_view(View.User)
      |> render("private_show.json",
        user: Service.User.Show.get_user!(resource_user.id),
        token: Guardian.Plug.current_token(conn)
      )
    end
  end

  operation :create,
    summary: "Create an Eamil",
    description: "Create and returns an Email",
    request_body:
      {"Create Email Body", "application/json", Schema.User.EmailCreate, required: true},
    responses: [
      ok: {"Create an Email Response", "application/json", Schema.User.Email}
    ],
    security: [%{"authorization" => []}]

  def create(conn = %{body_params: body_params}, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.Create.new(%{
             user_id: resource_user.id,
             email: body_params.email
           }),
         {:ok, email} <- Service.Email.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  operation :set_primary,
    summary: "Set Email as Primary",
    description: "Sets an Email as User's Primary Email",
    responses: [
      ok: {"Set Primary Email Response", "application/json", Schema.User.Email}
    ],
    parameters: [
      id: [in: :path, description: "Email Id", type: :integer, example: 113]
    ],
    security: [%{"authorization" => []}]

  def set_primary(conn, %{id: id}) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.SetPrimary.new(%{
             user_id: resource_user.id,
             email_id: id
           }),
         {:ok, email} <- Service.Email.SetPrimary.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  operation :delete,
    summary: "Delete an Email",
    description: "Delete a non-primary Email",
    responses: [
      no_content: "Empty response"
    ],
    parameters: [
      id: [in: :path, description: "Email Id", type: :integer, example: 113]
    ],
    security: [%{"authorization" => []}]

  def delete(conn, %{id: id}) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.Delete.new(%{user_id: resource_user.id, email_id: id}),
         {:ok, _email} <- Service.Email.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
