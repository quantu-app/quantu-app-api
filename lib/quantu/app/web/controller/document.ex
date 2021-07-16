defmodule Quantu.App.Web.Controller.Document do
  @moduledoc tags: ["Document"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, Uploader, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  require Record
  Record.defrecordp(:file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl"))

  @doc """
  List Documents

  Returns user's documents
  """
  @doc responses: [
         ok: {"User Documents", "application/json", Schema.Document.List}
       ]
  def index(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Document.Index.new(%{user_id: resource_user.id}),
         {:ok, documents} <- Service.Document.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Document)
      |> render("index.json", documents: documents)
    end
  end

  @doc """
  Get a Document

  Returns user's document
  """
  @doc responses: [
         ok: {"User Document", "application/json", Schema.Document.Show}
       ],
       parameters: [
         id: [in: :path, description: "Document Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Document.Show.new(%{document_id: params["id"], user_id: resource_user.id}),
         {:ok, document} <- Service.Document.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Document)
      |> render("show.json", document: document)
    end
  end

  @doc """
  Create a Document

  Returns user's created document
  """
  @doc request_body:
         {"Request body to create document", "application/json", Schema.Document.Create,
          required: true},
       responses: [
         ok: {"User Document", "application/json", Schema.Document.Show}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Document.Create.new(
             Map.merge(Util.underscore(params), %{"user_id" => resource_user.id})
           ),
         {:ok, document} <- Service.Document.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Document)
      |> render("show.json", document: document)
    end
  end

  @doc """
  Updates a Document

  Returns user's updated document
  """
  @doc request_body:
         {"Request body to update document", "application/json", Schema.Document.Update,
          required: true},
       responses: [
         ok: {"User Document", "application/json", Schema.Document.Show}
       ],
       parameters: [
         id: [in: :path, description: "Document Id", type: :string, example: "1001"]
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Document.Update.new(
             Map.merge(Util.underscore(params), %{
               "document_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, document} <- Service.Document.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Document)
      |> render("show.json", document: document)
    end
  end

  @doc """
  Uploads a Document's file

  Returns updated document
  """
  @doc request_body:
         {"Request body to update document", "application/json", Schema.Document.Upload,
          required: true},
       responses: [
         ok: {"User Document", "application/json", Schema.Document.Show}
       ],
       parameters: [
         id: [in: :path, description: "Document Id", type: :string, example: "1001"]
       ]
  def upload(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Document.Upload.new(
             Map.merge(Util.underscore(params), %{
               "document_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, document} <- Service.Document.Upload.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Document)
      |> render("show.json", document: document)
    end
  end

  @doc """
  Downloads a Document's file

  Returns Document's file
  """
  @doc request_body:
         {"Request body to update document", "application/json", Schema.Document.Update,
          required: true},
       responses: [
         ok: {"User Document", "application/json", Schema.Document.Show}
       ],
       parameters: [
         id: [in: :path, description: "Document Id", type: :string, example: "1001"]
       ]
  def download(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Document.Show.new(
             Map.merge(Util.underscore(params), %{
               "document_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, document} <- Service.Document.Show.handle(command) do
      if Mix.env() == :prod do
        conn
        |> put_status(302)
        |> redirect(url: Uploader.Document.url({document.url, document}, signed: true))
      else
        %URI{path: path} = URI.parse(Uploader.Document.url({document.url, document}))

        conn
        |> send_file(
          200,
          Application.get_env(:waffle, :storage_dir_prefix) <>
            path
        )
        |> halt()
      end
    end
  end
end
