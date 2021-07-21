defmodule Quantu.App.Web.Controller.CardTest do
  use Quantu.App.Web.Case

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.Guardian

  setup %{conn: conn} do
    user =
      Service.User.Create.new!(%{
        username: "username",
        password: "password",
        password_confirmation: "password"
      })
      |> Service.User.Create.handle!()

    deck =
      OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
      |> Util.underscore()
      |> Map.put("user_id", user.id)
      |> Service.Deck.Create.new!()
      |> Service.Deck.Create.handle!()

    {:ok,
     user: user,
     deck: deck,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("accept", "application/json")}
  end

  describe "get index/show" do
    test "should return list of cards", %{conn: conn, deck: deck} do
      %{id: card_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Create.schema())
        |> Util.underscore()
        |> Map.put("deck_id", deck.id)
        |> Service.Card.Create.new!()
        |> Service.Card.Create.handle!()

      conn =
        get(
          conn,
          Routes.deck_card_path(@endpoint, :index, deck.id)
        )

      cards_json = json_response(conn, 200)

      assert Enum.at(cards_json, 0)["id"] == card_id
    end

    test "should return a card", %{conn: conn, deck: deck} do
      %{id: card_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Create.schema())
        |> Util.underscore()
        |> Map.put("deck_id", deck.id)
        |> Service.Card.Create.new!()
        |> Service.Card.Create.handle!()

      conn =
        get(
          conn,
          Routes.deck_card_path(@endpoint, :show, deck.id, card_id)
        )

      card_json = json_response(conn, 200)

      assert card_json["id"] == card_id
    end
  end

  describe "create card" do
    test "should return created card", %{conn: conn, deck: deck} do
      create_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Create.schema())
        |> Util.underscore()
        |> Map.put("deck_id", deck.id)

      conn =
        post(
          conn,
          Routes.deck_card_path(@endpoint, :create, deck.id),
          create_params
        )

      card_json = json_response(conn, 201)

      assert card_json["name"] == create_params["name"]
    end
  end

  describe "update card" do
    test "should return updated card", %{conn: conn, deck: deck} do
      %{id: card_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Create.schema())
        |> Util.underscore()
        |> Map.put("deck_id", deck.id)
        |> Service.Card.Create.new!()
        |> Service.Card.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Update.schema())

      conn =
        put(
          conn,
          Routes.deck_card_path(@endpoint, :update, deck.id, card_id),
          update_params
        )

      card_json = json_response(conn, 200)

      assert card_json["name"] == update_params["name"]
    end
  end

  describe "delete card" do
    test "should delete card", %{conn: conn, deck: deck} do
      %{id: card_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Card.Create.schema())
        |> Util.underscore()
        |> Map.put("deck_id", deck.id)
        |> Service.Card.Create.new!()
        |> Service.Card.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.deck_card_path(@endpoint, :delete, deck.id, card_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.deck_card_path(@endpoint, :show, deck.id, card_id)
        )

      json_response(conn, 404)
    end
  end
end
