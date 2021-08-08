defmodule Quantu.App.Web.Controller.OrganizationTest do
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
          Routes.organization_path(@endpoint, :index)
        )

      organizations_json = json_response(conn, 200)

      assert_schema organizations_json, "OrganizationList", Quantu.App.Web.ApiSpec.spec()
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
          Routes.organization_path(@endpoint, :show, organization_id)
        )

      organization_json = json_response(conn, 200)

      assert_schema organization_json, "Organization", Quantu.App.Web.ApiSpec.spec()
      assert organization_json["id"] == organization_id
    end

    test "should return a organization by url", %{conn: conn, user: user} do
      %{url: url} =
        OpenApiSpex.Schema.example(Schema.Organization.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Organization.Create.new!()
        |> Service.Organization.Create.handle!()

      conn =
        get(
          conn,
          Routes.organization_path(@endpoint, :show_by_url, url)
        )

      organization_json = json_response(conn, 200)

      assert_schema organization_json, "Organization", Quantu.App.Web.ApiSpec.spec()
      assert organization_json["url"] == url
    end
  end
end
