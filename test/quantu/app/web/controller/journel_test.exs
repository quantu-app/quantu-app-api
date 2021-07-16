defmodule Quantu.App.Web.Controller.JournelTest do
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
    test "should return list of journels", %{conn: conn, user: user} do
      %{id: journel_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journel.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journel.Create.new!()
        |> Service.Journel.Create.handle!()

      conn =
        get(
          conn,
          Routes.journel_path(@endpoint, :index)
        )

      journels_json = json_response(conn, 200)

      assert Enum.at(journels_json, 0)["id"] == journel_id
    end

    test "should return a journel", %{conn: conn, user: user} do
      %{id: journel_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journel.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journel.Create.new!()
        |> Service.Journel.Create.handle!()

      conn =
        get(
          conn,
          Routes.journel_path(@endpoint, :show, journel_id)
        )

      journel_json = json_response(conn, 200)

      assert journel_json["id"] == journel_id
    end
  end

  describe "create journel" do
    test "should return created journel", %{conn: conn, user: user} do
      create_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journel.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)

      conn =
        post(
          conn,
          Routes.journel_path(@endpoint, :create),
          create_params
        )

      journel_json = json_response(conn, 201)

      assert journel_json["name"] == create_params["name"]
    end
  end

  describe "update journel" do
    test "should return updated journel", %{conn: conn, user: user} do
      %{id: journel_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journel.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Journel.Create.new!()
        |> Service.Journel.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Journel.Update.schema())

      conn =
        put(
          conn,
          Routes.journel_path(@endpoint, :update, journel_id),
          update_params
        )

      journel_json = json_response(conn, 200)

      assert journel_json["name"] == update_params["name"]
    end
  end
end
