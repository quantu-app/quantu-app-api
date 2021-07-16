defmodule Quantu.App.Web.Controller.User.PasswordTest do
  use Quantu.App.Web.Case

  alias Quantu.App.Service
  alias Quantu.App.Web.Guardian

  setup %{conn: conn} do
    user =
      Service.User.Create.new!(%{
        username: "username",
        password: "old_password",
        password_confirmation: "old_password"
      })
      |> Service.User.Create.handle!()

    conn = Guardian.Plug.sign_in(conn, user)

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "password reset" do
    test "should reset password", %{conn: conn} do
      conn =
        put(
          conn,
          Routes.password_path(@endpoint, :reset),
          %{
            "oldPassword" => "old_password",
            "password" => "password"
          }
        )

      json_response(conn, 201)
    end

    test "should fail to reset password if old password is invalid", %{conn: conn} do
      conn =
        put(
          conn,
          Routes.password_path(@endpoint, :reset),
          %{
            "oldPassword" => "invalid_old_password",
            "password" => "password"
          }
        )

      json_response(conn, 422)
    end
  end
end
