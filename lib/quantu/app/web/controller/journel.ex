defmodule Quantu.App.Web.Controller.Journel do
  @moduledoc tags: ["Journel"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  require Record
  Record.defrecordp(:file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl"))

  @doc """
  List Journels

  Returns user's journels
  """
  @doc responses: [
         ok: {"User Journels", "application/json", Schema.Journel.List}
       ]
  def index(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Journel.Index.new(%{user_id: resource_user.id}),
         {:ok, journels} <- Service.Journel.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journel)
      |> render("index.json", journels: journels)
    end
  end

  @doc """
  Get a Journel

  Returns user's journel
  """
  @doc responses: [
         ok: {"User Journel", "application/json", Schema.Journel.Show}
       ],
       parameters: [
         id: [in: :path, description: "Journel Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journel.Show.new(%{journel_id: params["id"], user_id: resource_user.id}),
         {:ok, journel} <- Service.Journel.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journel)
      |> render("show.json", journel: journel)
    end
  end

  @doc """
  Create a Journel

  Returns user's created journel
  """
  @doc request_body:
         {"Request body to create journel", "application/json", Schema.Journel.Create,
          required: true},
       responses: [
         ok: {"User Journel", "application/json", Schema.Journel.Show}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journel.Create.new(
             Map.merge(Util.underscore(params), %{"user_id" => resource_user.id})
           ),
         {:ok, journel} <- Service.Journel.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Journel)
      |> render("show.json", journel: journel)
    end
  end

  @doc """
  Updates a Journel

  Returns user's updated journel
  """
  @doc request_body:
         {"Request body to update journel", "application/json", Schema.Journel.Update,
          required: true},
       responses: [
         ok: {"User Journel", "application/json", Schema.Journel.Show}
       ],
       parameters: [
         id: [in: :path, description: "Journel Id", type: :string, example: "1001"]
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journel.Update.new(
             Map.merge(Util.underscore(params), %{
               "journel_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, journel} <- Service.Journel.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journel)
      |> render("show.json", journel: journel)
    end
  end

  @doc """
  Delete a Journel

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Journel Id", type: :string, example: "1001"]
       ]
  def delete(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journel.Delete.new(%{journel_id: params["id"], user_id: resource_user.id}),
         {:ok, _} <- Service.Journel.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
