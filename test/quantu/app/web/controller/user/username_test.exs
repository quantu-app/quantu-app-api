defmodule Quantu.App.Web.Controller.User.UsernameTest do
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
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("accept", "application/json")}
  end

  describe "update username" do
    test "should update user's username", %{conn: conn, user: user} do
      request_body = OpenApiSpex.Schema.example(Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.username_path(@endpoint, :update),
          request_body
        )

      assert user.username == "username"

      user = json_response(conn, 200)

      assert user["username"] == "new_username"
    end

    test "should fail to update user's username if already in use", %{conn: conn} do
      OpenApiSpex.Schema.example(Schema.SignUp.UsernamePassword.schema())
      |> Map.merge(OpenApiSpex.Schema.example(Schema.User.UsernameUpdate.schema()))
      |> Util.underscore()
      |> Service.User.Create.new!()
      |> Service.User.Create.handle!()

      request_body = OpenApiSpex.Schema.example(Schema.User.UsernameUpdate.schema())

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
