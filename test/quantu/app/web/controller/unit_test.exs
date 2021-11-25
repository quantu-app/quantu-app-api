defmodule Quantu.App.Web.Controller.UnitTest do
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
    test "should return list of units", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      conn =
        get(
          conn,
          Routes.unit_path(@endpoint, :index)
        )

      units_json = json_response(conn, 200)

      assert_schema(units_json, "UnitList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(units_json, 0)["id"] == unit_id
    end

    test "should not return list of non-published units", %{
      conn: conn,
      organization: organization
    } do
      OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
      |> Util.underscore()
      |> Map.put("organization_id", organization.id)
      |> Map.put("published", false)
      |> Service.Unit.Create.new!()
      |> Service.Unit.Create.handle!()

      conn =
        get(
          conn,
          Routes.unit_path(@endpoint, :index)
        )

      units_json = json_response(conn, 200)
      assert length(units_json) == 0
    end

    test "should return a unit", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      conn =
        get(
          conn,
          Routes.unit_path(@endpoint, :show, unit_id)
        )

      unit_json = json_response(conn, 200)

      assert_schema(unit_json, "Unit", Quantu.App.Web.ApiSpec.spec())
      assert unit_json["id"] == unit_id
    end

    test "should not return a non-published unit", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("published", false)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      conn =
        get(
          conn,
          Routes.unit_path(@endpoint, :show, unit_id)
        )

      json_response(conn, 404)
    end

    test "should return a unit's children", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      quiz =
        OpenApiSpex.Schema.example(Schema.Quiz.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("unit_id", unit_id)
        |> Map.put("published", false)
        |> Service.Quiz.Create.new!()
        |> Service.Quiz.Create.handle!()

      lesson =
        OpenApiSpex.Schema.example(Schema.Lesson.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("unit_id", unit_id)
        |> Map.put("published", false)
        |> Service.Lesson.Create.new!()
        |> Service.Lesson.Create.handle!()

      conn =
        get(
          conn,
          Routes.unit_path(@endpoint, :children, unit_id)
        )

      children_json = json_response(conn, 200)

      assert_schema(children_json, "UnitChildList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.any?(children_json, fn child -> child["id"] == quiz.id end) == true
      assert Enum.any?(children_json, fn child -> child["id"] == lesson.id end) == true
    end
  end
end
