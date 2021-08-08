defmodule Quantu.App.Web.Controller.User.QuizTest do
  use Quantu.App.Web.Case
  import OpenApiSpex.TestAssertions

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Guardian, Schema}

  setup %{conn: conn} do
    user =
      OpenApiSpex.Schema.example(Schema.SignUp.UsernamePassword.schema())
      |> Util.underscore()
      |> Service.User.Create.new!()
      |> Service.User.Create.handle!()

    organization =
      OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
      |> Util.underscore()
      |> Map.put("user_id", user.id)
      |> Service.Organization.Create.new!()
      |> Service.Organization.Create.handle!()

    {:ok,
     user: user,
     organization: organization,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("content-type", "application/json")}
  end

  describe "get index/show" do
    test "should return list of quizzes", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :index, organization.id)
        )

      quizzes_json = json_response(conn, 200)

      assert_schema quizzes_json, "QuizList", Quantu.App.Web.ApiSpec.spec()
      assert Enum.at(quizzes_json, 0)["id"] == quiz_id
    end

    test "should return a quiz", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :show, organization.id, quiz_id)
        )

      quiz_json = json_response(conn, 200)

      assert_schema quiz_json, "Quiz", Quantu.App.Web.ApiSpec.spec()
      assert quiz_json["id"] == quiz_id
    end
  end

  describe "create quiz" do
    test "should return created quiz", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)

      conn =
        post(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :create, organization.id),
          create_params
        )

      quiz_json = json_response(conn, 201)

      assert_schema quiz_json, "Quiz", Quantu.App.Web.ApiSpec.spec()
      assert quiz_json["name"] == create_params["name"]
    end
  end

  describe "update quiz" do
    test "should return updated quiz", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Schema.Quiz.Update.schema())

      conn =
        put(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :update, organization.id, quiz_id),
          update_params
        )

      quiz_json = json_response(conn, 200)

      assert_schema quiz_json, "Quiz", Quantu.App.Web.ApiSpec.spec()
      assert quiz_json["name"] == update_params["name"]
    end
  end

  describe "delete quiz" do
    test "should delete quiz", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :delete, organization.id, quiz_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_quiz_path(@endpoint, :show, organization.id, quiz_id)
        )

      json_response(conn, 404)
    end
  end
end
