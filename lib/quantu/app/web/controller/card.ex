defmodule Quantu.App.Web.Controller.Card do
  @moduledoc tags: ["Card"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  require Record
  Record.defrecordp(:file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl"))

  @doc """
  List Cards

  Returns deck's cards
  """
  @doc responses: [
         ok: {"User Cards", "application/json", Schema.Card.List}
       ],
       parameters: [
         deck_id: [in: :path, description: "Deck Id", type: :string, example: "1234"]
       ]
  def index(conn, params) do
    with {:ok, command} <- Service.Card.Index.new(%{deck_id: params["deck_id"]}),
         {:ok, cards} <- Service.Card.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Card)
      |> render("index.json", cards: cards)
    end
  end

  @doc """
  Get a Card

  Returns deck's card
  """
  @doc responses: [
         ok: {"User Card", "application/json", Schema.Card.Show}
       ],
       parameters: [
         deck_id: [in: :path, description: "Deck Id", type: :string, example: "1234"],
         id: [in: :path, description: "Card Id", type: :string, example: 1001]
       ]
  def show(conn, params) do
    with {:ok, command} <-
           Service.Card.Show.new(%{card_id: params["id"], deck_id: params["deck_id"]}),
         {:ok, card} <- Service.Card.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Card)
      |> render("show.json", card: card)
    end
  end

  @doc """
  Create a Card

  Returns deck's created card
  """
  @doc request_body:
         {"Request body to create card", "application/json", Schema.Card.Create, required: true},
       responses: [
         ok: {"User Card", "application/json", Schema.Card.Show}
       ],
       parameters: [
         deck_id: [in: :path, description: "Deck Id", type: :string, example: "1234"]
       ]
  def create(conn, params) do
    with {:ok, command} <-
           Service.Card.Create.new(
             Map.merge(Util.underscore(params), %{"deck_id" => params["deck_id"]})
           ),
         {:ok, card} <- Service.Card.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Card)
      |> render("show.json", card: card)
    end
  end

  @doc """
  Updates a Card

  Returns deck's updated card
  """
  @doc request_body:
         {"Request body to update card", "application/json", Schema.Card.Update, required: true},
       responses: [
         ok: {"User Card", "application/json", Schema.Card.Show}
       ],
       parameters: [
         deck_id: [in: :path, description: "Deck Id", type: :string, example: "1234"],
         id: [in: :path, description: "Card Id", type: :string, example: 1001]
       ]
  def update(conn, params) do
    with {:ok, command} <-
           Service.Card.Update.new(
             Map.merge(Util.underscore(params), %{
               "card_id" => Map.get(params, "id"),
               "deck_id" => params["deck_id"]
             })
           ),
         {:ok, card} <- Service.Card.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Card)
      |> render("show.json", card: card)
    end
  end

  @doc """
  Delete a Card

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         deck_id: [in: :path, description: "Deck Id", type: :string, example: "1234"],
         id: [in: :path, description: "Card Id", type: :string, example: 1001]
       ]
  def delete(conn, params) do
    with {:ok, command} <-
           Service.Card.Delete.new(%{card_id: params["id"], deck_id: params["deck_id"]}),
         {:ok, _} <- Service.Card.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
