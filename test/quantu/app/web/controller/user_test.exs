defmodule Quantu.App.Web.Controller.UserTest do
  use Quantu.App.Web.Case

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Guardian, Schema}

  setup %{conn: conn} do
    user =
      OpenApiSpex.Schema.example(Schema.SignUp.UsernamePassword.schema())
      |> Util.underscore()
      |> Service.User.Create.new!()
      |> Service.User.Create.handle!()

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("content-type", "application/json")}
  end

  describe "current" do
    test "should return current user", %{conn: conn, user: user} do
      conn = Guardian.Plug.sign_in(conn, user)

      conn =
        get(
          conn,
          Routes.auth_path(@endpoint, :current)
        )

      user_json = json_response(conn, 200)

      assert user_json["id"] == user.id
    end

    test "should return 401 with invalid token", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.auth_path(@endpoint, :current)
        )

      json_response(conn, 401)
    end
  end

  describe "sign_out" do
    test "should sign out current user", %{conn: conn, user: user} do
      conn = Guardian.Plug.sign_in(conn, user)

      conn =
        delete(
          conn,
          Routes.auth_path(@endpoint, :delete)
        )

      response(conn, 204)
    end
  end
end
