defmodule Quantu.App.Web.Controller.User.QuizQuestionTest do
  use Quantu.App.Web.Case

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

    quiz =
      OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Service.Quiz.Create.new!()
      |> Service.Quiz.Create.handle!()

    quiz_question_1 =
      OpenApiSpex.Schema.example(Schema.Question.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("quiz_id", quiz.id)
      |> Service.Question.Create.new!()
      |> Service.Question.Create.handle!()

    quiz_question_2 =
      OpenApiSpex.Schema.example(Schema.Question.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("quiz_id", quiz.id)
      |> Service.Question.Create.new!()
      |> Service.Question.Create.handle!()

    quiz_question_3 =
      OpenApiSpex.Schema.example(Schema.Question.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("quiz_id", quiz.id)
      |> Service.Question.Create.new!()
      |> Service.Question.Create.handle!()

    {:ok,
     user: user,
     organization: organization,
     quiz: quiz,
     quiz_question_1: quiz_question_1,
     quiz_question_2: quiz_question_2,
     quiz_question_3: quiz_question_3,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("content-type", "application/json")}
  end

  describe "quiz questions" do
    test "should move question from last to first and update quiz questions indices", %{
      conn: conn,
      organization: organization,
      quiz: quiz,
      quiz_question_1: quiz_question_1,
      quiz_question_2: quiz_question_2,
      quiz_question_3: quiz_question_3
    } do
      conn =
        put(
          conn,
          Routes.user_organization_question_path(
            @endpoint,
            :update,
            organization.id,
            quiz_question_3.id
          ),
          %{index: 0, quizId: quiz.id}
        )

      question_json = json_response(conn, 200)

      assert question_json["index"] == 0

      assert Service.Question.Show.handle!(%{
               question_id: quiz_question_1.id,
               quiz_id: quiz.id
             })
             |> Map.get(:index) == 1

      assert Service.Question.Show.handle!(%{
               question_id: quiz_question_2.id,
               quiz_id: quiz.id
             })
             |> Map.get(:index) == 2
    end
  end

  test "should move question from first to last and update quiz questions indices", %{
    conn: conn,
    organization: organization,
    quiz: quiz,
    quiz_question_1: quiz_question_1,
    quiz_question_2: quiz_question_2,
    quiz_question_3: quiz_question_3
  } do
    conn =
      put(
        conn,
        Routes.user_organization_question_path(
          @endpoint,
          :update,
          organization.id,
          quiz_question_1.id
        ),
        %{index: 2, quizId: quiz.id}
      )

    question_json = json_response(conn, 200)

    assert question_json["index"] == 2

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_2.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 0

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_3.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 1
  end

  test "should move question from first to middle and update quiz questions indices", %{
    conn: conn,
    organization: organization,
    quiz: quiz,
    quiz_question_1: quiz_question_1,
    quiz_question_2: quiz_question_2,
    quiz_question_3: quiz_question_3
  } do
    conn =
      put(
        conn,
        Routes.user_organization_question_path(
          @endpoint,
          :update,
          organization.id,
          quiz_question_1.id
        ),
        %{index: 1, quizId: quiz.id}
      )

    question_json = json_response(conn, 200)

    assert question_json["index"] == 1

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_2.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 0

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_3.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 2
  end

  test "should move question from last to middle and update quiz questions indices", %{
    conn: conn,
    organization: organization,
    quiz: quiz,
    quiz_question_1: quiz_question_1,
    quiz_question_2: quiz_question_2,
    quiz_question_3: quiz_question_3
  } do
    conn =
      put(
        conn,
        Routes.user_organization_question_path(
          @endpoint,
          :update,
          organization.id,
          quiz_question_3.id
        ),
        %{index: 1, quizId: quiz.id}
      )

    question_json = json_response(conn, 200)

    assert question_json["index"] == 1

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_1.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 0

    assert Service.Question.Show.handle!(%{
             question_id: quiz_question_2.id,
             quiz_id: quiz.id
           })
           |> Map.get(:index) == 2
  end
end
