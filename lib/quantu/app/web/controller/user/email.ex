defmodule Quantu.App.Web.Controller.User.Email do
  @moduledoc tags: ["User"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, Controller, View, Guardian}

  action_fallback(Controller.Fallback)

  @doc """
  Confirm an Eamil

  Confirms an Email and returns the User with the Bearer Token
  """
  @doc responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ],
       parameters: [
         confirmation_token: [
           in: :query,
           description: "Confirmation Token",
           type: :string,
           example: "qID3Z0xsVeDouJNjnKk5OxM9HsCtyY0gDJyU5bF2SjaBPjpkfqKBiim2W9v6nK"
         ]
       ]
  def confirm(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Email.Confirm.new(Util.underscore(params)),
         {:ok, _email} <- Service.Email.Confirm.handle(command) do
      conn
      |> put_view(View.User)
      |> render("private_show.json",
        user: Service.User.Show.get_user!(resource_user.id),
        token: Guardian.Plug.current_token(conn)
      )
    end
  end

  @doc """
  Create an Eamil

  Create and returns an Email
  """
  @doc request_body:
         {"Create Email Body", "application/json", Schema.User.EmailCreate, required: true},
       responses: [
         ok: {"Create an Email Response", "application/json", Schema.User.Email}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.Create.new(%{
             user_id: resource_user.id,
             email: Map.get(Util.underscore(params), "email")
           }),
         {:ok, email} <- Service.Email.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  @doc """
  Set Email as Primary

  Sets an Email as User's Primary Email
  """
  @doc responses: [
         ok: {"Set Primary Email Response", "application/json", Schema.User.Email}
       ],
       parameters: [
         id: [in: :path, description: "Email Id", type: :integer, example: 113]
       ]
  def set_primary(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.SetPrimary.new(%{
             user_id: resource_user.id,
             email_id: Map.get(params, "id")
           }),
         {:ok, email} <- Service.Email.SetPrimary.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  @doc """
  Delete an Email

  Delete a non-primary Email
  """
  @doc responses: [
         ok: {"Delete non-primary Email Response", "application/json", Schema.User.Email}
       ],
       parameters: [
         id: [in: :path, description: "Email Id", type: :integer, example: 113]
       ]
  def delete(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Email.Delete.new(%{user_id: resource_user.id, email_id: Map.get(params, "id")}),
         {:ok, email} <- Service.Email.Delete.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end
end
