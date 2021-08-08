defmodule Quantu.App.Web.Controller.Auth.SignUpTest do
  use Quantu.App.Web.Case
  import OpenApiSpex.TestAssertions

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("content-type", "application/json")}
  end

  describe "username_and_password" do
    test "should sign up with username and password", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.sign_up_path(@endpoint, :sign_up),
          %{
            username: "username",
            password: "password",
            passwordConfirmation: "password"
          }
        )

      user_json = json_response(conn, 201)

      assert_schema user_json, "User", Quantu.App.Web.ApiSpec.spec()
    end
  end
end
