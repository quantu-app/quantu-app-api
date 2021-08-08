defmodule Quantu.App.Web.Controller.Auth.SignInTest do
  use Quantu.App.Web.Case
  import OpenApiSpex.TestAssertions

  alias Quantu.App.Service

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("content-type", "application/json")}
  end

  describe "username_or_email_and_password" do
    test "should sign in with email and password", %{conn: conn} do
      user = create_user!()

      conn =
        post(
          conn,
          Routes.sign_in_path(@endpoint, :sign_in),
          %{
            usernameOrEmail: "email@domain.com",
            password: "password"
          }
        )

      user_json = json_response(conn, 200)

      assert_schema user_json, "User", Quantu.App.Web.ApiSpec.spec()
      assert user_json["id"] == user.id
    end

    test "should sign in with username and password", %{conn: conn} do
      user = create_user!()

      conn =
        post(
          conn,
          Routes.sign_in_path(@endpoint, :sign_in),
          %{
            usernameOrEmail: "username",
            password: "password"
          }
        )

      user_json = json_response(conn, 200)

      assert_schema user_json, "User", Quantu.App.Web.ApiSpec.spec()
      assert user_json["id"] == user.id
    end

    test "should fail to sign in with invalid email", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.sign_in_path(@endpoint, :sign_in),
          %{
            usernameOrEmail: "wrong@domain.com",
            password: "password"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["username_or_email"] == [
               Service.User.ShowWithUsernameOrEmailAndPassword.no_match_error()
             ]

      assert error_json["errors"]["password"] == [
               Service.User.ShowWithUsernameOrEmailAndPassword.no_match_error()
             ]
    end

    test "should fail to sign in with invalid password", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.sign_in_path(@endpoint, :sign_in),
          %{
            usernameOrEmail: "email@domain.com",
            password: "wrong"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["username_or_email"] == [
               Service.User.ShowWithUsernameOrEmailAndPassword.no_match_error()
             ]

      assert error_json["errors"]["password"] == [
               Service.User.ShowWithUsernameOrEmailAndPassword.no_match_error()
             ]
    end
  end

  defp create_user!() do
    user =
      Service.User.Create.new!(%{
        username: "username",
        password: "password",
        password_confirmation: "password"
      })
      |> Service.User.Create.handle!()

    Service.Email.Create.handle!(%{user_id: user.id, email: "email@domain.com"})

    Service.User.Show.handle!(%{user_id: user.id})
  end
end
