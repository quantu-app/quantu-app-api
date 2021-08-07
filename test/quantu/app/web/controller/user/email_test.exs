defmodule Quantu.App.Web.Controller.User.EmailTest do
  use Quantu.App.Web.Case

  alias Quantu.App.{Service, Repo, Model, Util}
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

  describe "create" do
    test "should create a new email", %{conn: conn, user: user} do
      request_body = OpenApiSpex.Schema.example(Schema.User.EmailCreate.schema())

      conn =
        post(
          conn,
          Routes.user_email_path(@endpoint, :create),
          request_body
        )

      email = json_response(conn, 201)

      assert email["email"] == "example@domain.com"
      assert email["userId"] == user.id
    end

    test "should fail to create a new email if already in use", %{conn: conn, user: user} do
      Service.Email.Create.handle!(%{user_id: user.id, email: "email@domain.com"})

      conn =
        post(
          conn,
          Routes.user_email_path(@endpoint, :create),
          %{
            "email" => "email@domain.com"
          }
        )

      email = json_response(conn, 422)

      assert email["errors"]["email"] == ["has already been taken"]
    end
  end

  describe "confirm" do
    test "should confirm email", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "email@domain.com",
          primary: true
        })

      confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, user_id: user.id, email_id: email.id)

      conn =
        put(
          conn,
          Routes.user_email_path(@endpoint, :confirm),
          %{
            "confirmation_token" => confirmation_token.confirmation_token
          }
        )

      user = json_response(conn, 200)

      assert user["email"]["confirmed"] == true
    end
  end

  describe "set primary" do
    test "should set email to primary", %{conn: conn, user: user} do
      old_email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example1@domain.com",
          primary: true
        })

      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example2@domain.com"
        })

      conn =
        put(
          conn,
          Routes.user_email_path(@endpoint, :set_primary, email.id)
        )

      email = json_response(conn, 200)

      assert email["primary"] == true
      assert Repo.get!(Model.Email, old_email.id).primary == false
    end
  end

  describe "delete" do
    test "should delete email", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "email@domain.com"
        })

      conn =
        delete(
          conn,
          Routes.user_email_path(@endpoint, :delete, email.id)
        )

      json_response(conn, 200)
    end

    test "should fail to delete email if primary", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "email@domain.com",
          primary: true
        })

      conn =
        delete(
          conn,
          Routes.user_email_path(@endpoint, :delete, email.id)
        )

      json_response(conn, 404)
    end
  end
end
