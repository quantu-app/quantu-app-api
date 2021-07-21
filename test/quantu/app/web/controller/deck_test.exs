defmodule Quantu.App.Web.Controller.DeckTest do
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

    {:ok,
     user: user,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("accept", "application/json")}
  end

  describe "get index/show" do
    test "should return list of decks", %{conn: conn, user: user} do
      %{id: deck_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Deck.Create.new!()
        |> Service.Deck.Create.handle!()

      conn =
        get(
          conn,
          Routes.deck_path(@endpoint, :index)
        )

      decks_json = json_response(conn, 200)

      assert Enum.at(decks_json, 0)["id"] == deck_id
    end

    test "should return a deck", %{conn: conn, user: user} do
      %{id: deck_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Deck.Create.new!()
        |> Service.Deck.Create.handle!()

      conn =
        get(
          conn,
          Routes.deck_path(@endpoint, :show, deck_id)
        )

      deck_json = json_response(conn, 200)

      assert deck_json["id"] == deck_id
    end
  end

  describe "create deck" do
    test "should return created deck", %{conn: conn, user: user} do
      create_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)

      conn =
        post(
          conn,
          Routes.deck_path(@endpoint, :create),
          create_params
        )

      deck_json = json_response(conn, 201)

      assert deck_json["name"] == create_params["name"]
    end
  end

  describe "update deck" do
    test "should return updated deck", %{conn: conn, user: user} do
      %{id: deck_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Deck.Create.new!()
        |> Service.Deck.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Update.schema())

      conn =
        put(
          conn,
          Routes.deck_path(@endpoint, :update, deck_id),
          update_params
        )

      deck_json = json_response(conn, 200)

      assert deck_json["name"] == update_params["name"]
    end
  end

  describe "delete deck" do
    test "should delete deck", %{conn: conn, user: user} do
      %{id: deck_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Deck.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Deck.Create.new!()
        |> Service.Deck.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.deck_path(@endpoint, :delete, deck_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.deck_path(@endpoint, :show, deck_id)
        )

      json_response(conn, 404)
    end
  end
end
