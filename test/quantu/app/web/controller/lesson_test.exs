defmodule Quantu.App.Web.Controller.LessonTest do
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
    test "should return list of lessons", %{conn: conn, organization: organization} do
      %{id: lesson_id} =
        OpenApiSpex.Schema.example(Schema.Lesson.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Lesson.Create.new!()
        |> Service.Lesson.Create.handle!()

      conn =
        get(
          conn,
          Routes.lesson_path(@endpoint, :index)
        )

      lessons_json = json_response(conn, 200)

      assert_schema(lessons_json, "LessonList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(lessons_json, 0)["id"] == lesson_id
    end

    test "should not return list of non-published lessons", %{
      conn: conn,
      organization: organization
    } do
      OpenApiSpex.Schema.example(Schema.Lesson.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("published", false)
      |> Service.Lesson.Create.new!()
      |> Service.Lesson.Create.handle!()

      conn =
        get(
          conn,
          Routes.lesson_path(@endpoint, :index)
        )

      lessons_json = json_response(conn, 200)
      assert length(lessons_json) == 0
    end

    test "should return a lesson", %{conn: conn, organization: organization} do
      %{id: lesson_id} =
        OpenApiSpex.Schema.example(Schema.Lesson.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Lesson.Create.new!()
        |> Service.Lesson.Create.handle!()

      conn =
        get(
          conn,
          Routes.lesson_path(@endpoint, :show, lesson_id)
        )

      lesson_json = json_response(conn, 200)

      assert_schema(lesson_json, "Lesson", Quantu.App.Web.ApiSpec.spec())
      assert lesson_json["id"] == lesson_id
    end

    test "should not return a non-published lesson", %{conn: conn, organization: organization} do
      %{id: lesson_id} =
        OpenApiSpex.Schema.example(Schema.Lesson.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("published", false)
        |> Service.Lesson.Create.new!()
        |> Service.Lesson.Create.handle!()

      conn =
        get(
          conn,
          Routes.lesson_path(@endpoint, :show, lesson_id)
        )

      json_response(conn, 404)
    end
  end
end
