defmodule Quantu.App.Web.Controller.QuizTest do
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

    Service.User.Creator.handle!(%{user_id: user.id, creator: true})

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
          Routes.quiz_path(@endpoint, :index)
        )

      quizzes_json = json_response(conn, 200)

      assert_schema(quizzes_json, "QuizList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(quizzes_json, 0)["id"] == quiz_id
    end

    test "should not return list of non-published quizzes", %{
      conn: conn,
      organization: organization
    } do
      OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("published", false)
      |> Service.Quiz.Create.new!()
      |> Service.Quiz.Create.handle!()

      conn =
        get(
          conn,
          Routes.quiz_path(@endpoint, :index)
        )

      quizzes_json = json_response(conn, 200)
      assert length(quizzes_json) == 0
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
          Routes.quiz_path(@endpoint, :show, quiz_id)
        )

      quiz_json = json_response(conn, 200)

      assert_schema(quiz_json, "Quiz", Quantu.App.Web.ApiSpec.spec())
      assert quiz_json["id"] == quiz_id
    end

    test "should not return a non-published quiz", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("published", false)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      conn =
        get(
          conn,
          Routes.quiz_path(@endpoint, :show, quiz_id)
        )

      json_response(conn, 404)
    end
  end
end
