defmodule Quantu.App.Web.Controller.Journal do
  @moduledoc tags: ["Journal"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  require Record
  Record.defrecordp(:file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl"))

  @doc """
  List Journals

  Returns user's journals
  """
  @doc responses: [
         ok: {"User Journals", "application/json", Schema.Journal.List}
       ]
  def index(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Journal.Index.new(%{user_id: resource_user.id}),
         {:ok, journals} <- Service.Journal.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journal)
      |> render("index.json", journals: journals)
    end
  end

  @doc """
  Get a Journal

  Returns user's journal
  """
  @doc responses: [
         ok: {"User Journal", "application/json", Schema.Journal.Show}
       ],
       parameters: [
         id: [in: :path, description: "Journal Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journal.Show.new(%{journal_id: params["id"], user_id: resource_user.id}),
         {:ok, journal} <- Service.Journal.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journal)
      |> render("show.json", journal: journal)
    end
  end

  @doc """
  Create a Journal

  Returns user's created journal
  """
  @doc request_body:
         {"Request body to create journal", "application/json", Schema.Journal.Create,
          required: true},
       responses: [
         ok: {"User Journal", "application/json", Schema.Journal.Show}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journal.Create.new(
             Map.merge(Util.underscore(params), %{"user_id" => resource_user.id})
           ),
         {:ok, journal} <- Service.Journal.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Journal)
      |> render("show.json", journal: journal)
    end
  end

  @doc """
  Updates a Journal

  Returns user's updated journal
  """
  @doc request_body:
         {"Request body to update journal", "application/json", Schema.Journal.Update,
          required: true},
       responses: [
         ok: {"User Journal", "application/json", Schema.Journal.Show}
       ],
       parameters: [
         id: [in: :path, description: "Journal Id", type: :string, example: "1001"]
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journal.Update.new(
             Map.merge(Util.underscore(params), %{
               "journal_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, journal} <- Service.Journal.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Journal)
      |> render("show.json", journal: journal)
    end
  end

  @doc """
  Delete a Journal

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Journal Id", type: :string, example: "1001"]
       ]
  def delete(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Journal.Delete.new(%{journal_id: params["id"], user_id: resource_user.id}),
         {:ok, _} <- Service.Journal.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
