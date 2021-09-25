defmodule Quantu.App.Web.Controller.User.OrganizationTest do
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

    {:ok,
     user: user,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("content-type", "application/json")}
  end

  describe "get index/show" do
    test "should return list of organizations", %{conn: conn, user: user} do
      %{id: organization_id} =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Organization.Create.new!()
        |> Service.Organization.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_path(@endpoint, :index)
        )

      organizations_json = json_response(conn, 200)

      assert_schema(organizations_json, "OrganizationList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(organizations_json, 0)["id"] == organization_id
    end

    test "should return a organization", %{conn: conn, user: user} do
      %{id: organization_id} =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Organization.Create.new!()
        |> Service.Organization.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_path(@endpoint, :show, organization_id)
        )

      organization_json = json_response(conn, 200)

      assert_schema(organization_json, "Organization", Quantu.App.Web.ApiSpec.spec())
      assert organization_json["id"] == organization_id
    end
  end

  describe "create organization" do
    test "should return created organization", %{conn: conn} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()

      conn =
        post(
          conn,
          Routes.user_organization_path(@endpoint, :create),
          create_params
        )

      organization_json = json_response(conn, 201)

      assert_schema(organization_json, "Organization", Quantu.App.Web.ApiSpec.spec())
      assert organization_json["name"] == create_params["name"]
    end
  end

  describe "update organization" do
    test "should return updated organization", %{conn: conn, user: user} do
      %{id: organization_id} =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Organization.Create.new!()
        |> Service.Organization.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Schema.Organization.Update.schema())

      conn =
        put(
          conn,
          Routes.user_organization_path(@endpoint, :update, organization_id),
          update_params
        )

      organization_json = json_response(conn, 200)

      assert_schema(organization_json, "Organization", Quantu.App.Web.ApiSpec.spec())
      assert organization_json["name"] == update_params["name"]
    end
  end

  describe "delete organization" do
    test "should delete organization", %{conn: conn, user: user} do
      %{id: organization_id} =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Organization.Create.new!()
        |> Service.Organization.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_path(@endpoint, :delete, organization_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_path(@endpoint, :show, organization_id)
        )

      json_response(conn, 404)
    end
  end
end
