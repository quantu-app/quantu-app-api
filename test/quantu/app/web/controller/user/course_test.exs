defmodule Quantu.App.Web.Controller.User.CourseTest do
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
    test "should return list of courses", %{conn: conn, organization: organization} do
      %{id: course_id} =
        OpenApiSpex.Schema.example(Schema.Course.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Course.Create.new!()
        |> Service.Course.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_course_path(@endpoint, :index, organization.id)
        )

      courses_json = json_response(conn, 200)

      assert_schema(courses_json, "CourseList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(courses_json, 0)["id"] == course_id
    end

    test "should return a course", %{conn: conn, organization: organization} do
      %{id: course_id} =
        OpenApiSpex.Schema.example(Schema.Course.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Course.Create.new!()
        |> Service.Course.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_course_path(@endpoint, :show, organization.id, course_id)
        )

      course_json = json_response(conn, 200)

      assert_schema(course_json, "Course", Quantu.App.Web.ApiSpec.spec())
      assert course_json["id"] == course_id
    end
  end

  describe "create course" do
    test "should return created course", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Course.Create.schema())
        |> Util.underscore()

      conn =
        post(
          conn,
          Routes.user_organization_course_path(@endpoint, :create, organization.id),
          create_params
        )

      course_json = json_response(conn, 201)

      assert_schema(course_json, "Course", Quantu.App.Web.ApiSpec.spec())
      assert course_json["name"] == create_params["name"]
    end
  end

  describe "update course" do
    test "should return updated course", %{conn: conn, organization: organization} do
      %{id: course_id} =
        OpenApiSpex.Schema.example(Schema.Course.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Course.Create.new!()
        |> Service.Course.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Schema.Course.Update.schema())

      conn =
        put(
          conn,
          Routes.user_organization_course_path(@endpoint, :update, organization.id, course_id),
          update_params
        )

      course_json = json_response(conn, 200)

      assert_schema(course_json, "Course", Quantu.App.Web.ApiSpec.spec())
      assert course_json["name"] == update_params["name"]
    end
  end

  describe "delete course" do
    test "should delete course", %{conn: conn, organization: organization} do
      %{id: course_id} =
        OpenApiSpex.Schema.example(Schema.Course.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Course.Create.new!()
        |> Service.Course.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_course_path(@endpoint, :delete, organization.id, course_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_course_path(@endpoint, :show, organization.id, course_id)
        )

      json_response(conn, 404)
    end
  end
end
