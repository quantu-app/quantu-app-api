defmodule Quantu.App.Web.Controller.QuestionTest do
  use Quantu.App.Web.Case

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
       |> put_req_header("accept", "application/json")}
  end

  describe "get index/show" do
    test "should return list of questions", %{conn: conn, organization: organization} do
      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      conn =
        get(
          conn,
          Routes.organization_question_path(@endpoint, :index, organization.id)
        )

      questions_json = json_response(conn, 200)

      assert Enum.at(questions_json, 0)["id"] == question_id
    end

    test "should return list of questions for a quiz", %{conn: conn, organization: organization} do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("quiz_id", quiz_id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      conn =
        get(
          conn,
          Routes.organization_question_path(@endpoint, :index, organization.id, quiz_id: quiz_id)
        )

      questions_json = json_response(conn, 200)

      assert Enum.at(questions_json, 0)["id"] == question_id
    end

    test "should return a question", %{conn: conn, organization: organization} do
      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      conn =
        get(
          conn,
          Routes.organization_question_path(@endpoint, :show, organization.id, question_id)
        )

      question_json = json_response(conn, 200)

      assert question_json["id"] == question_id
    end
  end
end
