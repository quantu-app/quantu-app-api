defmodule Quantu.App.Web.Controller.Deck do
  @moduledoc tags: ["Deck"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  require Record
  Record.defrecordp(:file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl"))

  @doc """
  List Decks

  Returns user's decks
  """
  @doc responses: [
         ok: {"User Decks", "application/json", Schema.Deck.List}
       ]
  def index(conn, _params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Deck.Index.new(%{user_id: resource_user.id}),
         {:ok, decks} <- Service.Deck.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Deck)
      |> render("index.json", decks: decks)
    end
  end

  @doc """
  Get a Deck

  Returns user's deck
  """
  @doc responses: [
         ok: {"User Deck", "application/json", Schema.Deck.Show}
       ],
       parameters: [
         id: [in: :path, description: "Deck Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Deck.Show.new(%{deck_id: params["id"], user_id: resource_user.id}),
         {:ok, deck} <- Service.Deck.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Deck)
      |> render("show.json", deck: deck)
    end
  end

  @doc """
  Create a Deck

  Returns user's created deck
  """
  @doc request_body:
         {"Request body to create deck", "application/json", Schema.Deck.Create, required: true},
       responses: [
         ok: {"User Deck", "application/json", Schema.Deck.Show}
       ]
  def create(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Deck.Create.new(
             Map.merge(Util.underscore(params), %{"user_id" => resource_user.id})
           ),
         {:ok, deck} <- Service.Deck.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Deck)
      |> render("show.json", deck: deck)
    end
  end

  @doc """
  Updates a Deck

  Returns user's updated deck
  """
  @doc request_body:
         {"Request body to update deck", "application/json", Schema.Deck.Update, required: true},
       responses: [
         ok: {"User Deck", "application/json", Schema.Deck.Show}
       ],
       parameters: [
         id: [in: :path, description: "Deck Id", type: :string, example: "1001"]
       ]
  def update(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Deck.Update.new(
             Map.merge(Util.underscore(params), %{
               "deck_id" => Map.get(params, "id"),
               "user_id" => resource_user.id
             })
           ),
         {:ok, deck} <- Service.Deck.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Deck)
      |> render("show.json", deck: deck)
    end
  end

  @doc """
  Delete a Deck

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Deck Id", type: :string, example: "1001"]
       ]
  def delete(conn, params) do
    resource_user = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Deck.Delete.new(%{deck_id: params["id"], user_id: resource_user.id}),
         {:ok, _} <- Service.Deck.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
