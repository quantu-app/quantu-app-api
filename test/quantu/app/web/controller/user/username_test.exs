defmodule Quantu.App.Web.Controller.User.UsernameTest do
  use Quantu.App.Web.Case

  alias Quantu.App.Service
  alias Quantu.App.Web.Guardian

  setup %{conn: conn} do
    user =
      Service.User.Create.new!(%{
        username: "old_username",
        password: "password",
        password_confirmation: "password"
      })
      |> Service.User.Create.handle!()

    conn = Guardian.Plug.sign_in(conn, user)

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "update username" do
    test "should update user's username", %{conn: conn, user: user} do
      request_body =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.username_path(@endpoint, :update),
          request_body
        )

      assert user.username == "old_username"

      user = json_response(conn, 200)

      assert user["username"] == "username"
    end

    test "should fail to update user's username if already in use", %{conn: conn} do
      Service.User.Create.new!(%{
        username: "username",
        password: "password",
        password_confirmation: "password"
      })
      |> Service.User.Create.handle!()

      request_body =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.username_path(@endpoint, :update),
          request_body
        )

      response = json_response(conn, 422)

      assert response["errors"]["username"] == ["has already been taken"]
    end
  end
end
