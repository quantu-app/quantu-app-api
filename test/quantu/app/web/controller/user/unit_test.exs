defmodule Quantu.App.Web.Controller.User.UnitTest do
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
          Routes.user_organization_unit_path(@endpoint, :index, organization.id)
        )

      units_json = json_response(conn, 200)

      assert_schema(units_json, "UnitList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(units_json, 0)["id"] == unit_id
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
          Routes.user_organization_unit_path(@endpoint, :show, organization.id, unit_id)
        )

      unit_json = json_response(conn, 200)

      assert_schema(unit_json, "Unit", Quantu.App.Web.ApiSpec.spec())
      assert unit_json["id"] == unit_id
    end
  end

  describe "create unit" do
    test "should return created unit", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()

      conn =
        post(
          conn,
          Routes.user_organization_unit_path(@endpoint, :create, organization.id),
          create_params
        )

      unit_json = json_response(conn, 201)

      assert_schema(unit_json, "Unit", Quantu.App.Web.ApiSpec.spec())
      assert unit_json["name"] == create_params["name"]
    end
  end

  describe "update unit" do
    test "should return updated unit", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Schema.Unit.Update.schema())

      conn =
        put(
          conn,
          Routes.user_organization_unit_path(@endpoint, :update, organization.id, unit_id),
          update_params
        )

      unit_json = json_response(conn, 200)

      assert_schema(unit_json, "Unit", Quantu.App.Web.ApiSpec.spec())
      assert unit_json["name"] == update_params["name"]
    end
  end

  describe "delete unit" do
    test "should delete unit", %{conn: conn, organization: organization} do
      %{id: unit_id} =
        OpenApiSpex.Schema.example(Schema.Unit.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Service.Unit.Create.new!()
        |> Service.Unit.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_unit_path(@endpoint, :delete, organization.id, unit_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_unit_path(@endpoint, :show, organization.id, unit_id)
        )

      json_response(conn, 404)
    end
  end
end
