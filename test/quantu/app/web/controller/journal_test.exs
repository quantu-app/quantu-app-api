defmodule Quantu.App.Web.Controller.JournalTest do
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
    test "should return list of journals", %{conn: conn, user: user} do
      %{id: journal_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journal.Create.new!()
        |> Service.Journal.Create.handle!()

      conn =
        get(
          conn,
          Routes.journal_path(@endpoint, :index)
        )

      journals_json = json_response(conn, 200)

      assert Enum.at(journals_json, 0)["id"] == journal_id
    end

    test "should return a journal", %{conn: conn, user: user} do
      %{id: journal_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journal.Create.new!()
        |> Service.Journal.Create.handle!()

      conn =
        get(
          conn,
          Routes.journal_path(@endpoint, :show, journal_id)
        )

      journal_json = json_response(conn, 200)

      assert journal_json["id"] == journal_id
    end
  end

  describe "create journal" do
    test "should return created journal", %{conn: conn, user: user} do
      create_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)

      conn =
        post(
          conn,
          Routes.journal_path(@endpoint, :create),
          create_params
        )

      journal_json = json_response(conn, 201)

      assert journal_json["name"] == create_params["name"]
    end
  end

  describe "update journal" do
    test "should return updated journal", %{conn: conn, user: user} do
      %{id: journal_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journal.Create.new!()
        |> Service.Journal.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Update.schema())

      conn =
        put(
          conn,
          Routes.journal_path(@endpoint, :update, journal_id),
          update_params
        )

      journal_json = json_response(conn, 200)

      assert journal_json["name"] == update_params["name"]
    end
  end

  describe "delete journal" do
    test "should delete journal", %{conn: conn, user: user} do
      %{id: journal_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journal.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journal.Create.new!()
        |> Service.Journal.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.journal_path(@endpoint, :delete, journal_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.journal_path(@endpoint, :show, journal_id)
        )

      json_response(conn, 404)
    end
  end
end
