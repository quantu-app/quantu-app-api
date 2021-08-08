defmodule Quantu.App.Web.Controller.User.QuestionTest do
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
       |> put_req_header("content-type", "application/json")}
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
          Routes.user_organization_question_path(@endpoint, :index, organization.id)
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
          Routes.user_organization_question_path(@endpoint, :index, organization.id,
            quizId: quiz_id
          )
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
          Routes.user_organization_question_path(@endpoint, :show, organization.id, question_id)
        )

      question_json = json_response(conn, 200)

      assert question_json["id"] == question_id
    end
  end

  describe "create question" do
    test "should return created question", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)

      conn =
        post(
          conn,
          Routes.user_organization_question_path(@endpoint, :create, organization.id),
          create_params
        )

      question_json = json_response(conn, 201)

      assert question_json["type"] == create_params["type"]
    end

    test "should fail to create question", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("prompt", %{})

      conn =
        post(
          conn,
          Routes.user_organization_question_path(@endpoint, :create, organization.id),
          create_params
        )

      json_response(conn, 422)
    end

    test "should created question with new index for quiz", %{
      conn: conn,
      organization: organization
    } do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      OpenApiSpex.Schema.example(Schema.Question.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("quiz_id", quiz_id)
      |> Service.Question.Create.new!()
      |> Service.Question.Create.handle!()

      create_params =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Map.put("quizId", quiz_id)

      conn =
        post(
          conn,
          Routes.user_organization_question_path(
            @endpoint,
            :create,
            organization.id
          ),
          create_params
        )

      question_json = json_response(conn, 201)

      assert question_json["type"] == create_params["type"]
      assert question_json["index"] == 1
    end
  end

  describe "update question" do
    test "should return updated question", %{conn: conn, organization: organization} do
      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Schema.Question.Update.schema())

      conn =
        put(
          conn,
          Routes.user_organization_question_path(
            @endpoint,
            :update,
            organization.id,
            question_id
          ),
          update_params
        )

      question_json = json_response(conn, 200)

      assert question_json["type"] == update_params["type"]
    end

    test "should return updated question and update quiz questions indices", %{
      conn: conn,
      organization: organization
    } do
      %{id: quiz_id} =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      %{id: first_question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("quiz_id", quiz_id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("quiz_id", quiz_id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      update_params =
        OpenApiSpex.Schema.example(Schema.Question.Update.schema())
        |> Map.put("index", 0)
        |> Map.put("quizId", quiz_id)

      conn =
        put(
          conn,
          Routes.user_organization_question_path(
            @endpoint,
            :update,
            organization.id,
            question_id
          ),
          update_params
        )

      question_json = json_response(conn, 200)

      assert question_json["type"] == update_params["type"]
      assert question_json["index"] == 0

      first_question =
        Service.Question.Show.handle!(%{question_id: first_question_id, quiz_id: quiz_id})

      assert Map.get(first_question, :index) == 1
    end
  end

  describe "delete question" do
    test "should delete question", %{conn: conn, organization: organization} do
      %{id: question_id} =
        OpenApiSpex.Schema.example(Schema.Question.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Question.Create.new!()
        |> Service.Question.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_question_path(@endpoint, :delete, organization.id, question_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_question_path(@endpoint, :show, organization.id, question_id)
        )

      json_response(conn, 404)
    end
  end
end
