defmodule Quantu.App.Web.Controller.User.PasswordTest do
  use Quantu.App.Web.Case

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Guardian, Schema}

  setup %{conn: conn} do
    user =
      OpenApiSpex.Schema.example(Schema.SignUp.UsernamePassword.schema())
      |> Util.underscore()
      |> Service.User.Create.new!()
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
          Routes.user_password_path(@endpoint, :reset),
          %{
            "oldPassword" => "password",
            "password" => "new_password"
          }
        )

      json_response(conn, 201)
    end

    test "should fail to reset password if old password is invalid", %{conn: conn} do
      conn =
        put(
          conn,
          Routes.user_password_path(@endpoint, :reset),
          %{
            "oldPassword" => "invalid_old_password",
            "password" => "password"
          }
        )

      json_response(conn, 422)
    end
  end
end
