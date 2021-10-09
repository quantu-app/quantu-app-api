defmodule Quantu.App.Web.Controller.User.AssetTest do
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
    test "should return list of assets", %{conn: conn, organization: organization} do
      %{id: asset_id} =
        OpenApiSpex.Schema.example(Schema.Asset.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("name", %Plug.Upload{path: "test/fixtures/test.png", filename: "test.png"})
        |> Service.Asset.Create.new!()
        |> Service.Asset.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_asset_path(@endpoint, :index, organization.id)
        )

      assets_json = json_response(conn, 200)

      assert_schema(assets_json, "AssetList", Quantu.App.Web.ApiSpec.spec())
      assert Enum.at(assets_json, 0)["id"] == asset_id
    end

    test "should return a asset", %{conn: conn, organization: organization} do
      %{id: asset_id} =
        OpenApiSpex.Schema.example(Schema.Asset.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("name", %Plug.Upload{path: "test/fixtures/test.png", filename: "test.png"})
        |> Service.Asset.Create.new!()
        |> Service.Asset.Create.handle!()

      conn =
        get(
          conn,
          Routes.user_organization_asset_path(@endpoint, :show, organization.id, asset_id)
        )

      asset_json = json_response(conn, 200)

      assert_schema(asset_json, "Asset", Quantu.App.Web.ApiSpec.spec())
      assert asset_json["id"] == asset_id
    end
  end

  describe "create asset" do
    test "should return created asset", %{conn: conn, organization: organization} do
      create_params =
        OpenApiSpex.Schema.example(Schema.Asset.Create.schema())
        |> Map.put("name", %Plug.Upload{path: "test/fixtures/test.png", filename: "test.png"})

      conn =
        post(
          conn |> put_req_header("content-type", "multipart/form-data"),
          Routes.user_organization_asset_path(@endpoint, :create, organization.id),
          create_params
        )

      asset_json = json_response(conn, 201)

      assert_schema(asset_json, "Asset", Quantu.App.Web.ApiSpec.spec())
      assert asset_json["name"] == create_params["name"].filename
    end
  end

  describe "update asset" do
    test "should return updated asset", %{conn: conn, organization: organization} do
      %{id: asset_id} =
        OpenApiSpex.Schema.example(Schema.Asset.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("name", %Plug.Upload{path: "test/fixtures/test.png", filename: "test.png"})
        |> Service.Asset.Create.new!()
        |> Service.Asset.Create.handle!()

      update_params =
        OpenApiSpex.Schema.example(Schema.Asset.Update.schema())
        |> Map.put("name", %Plug.Upload{
          path: "test/fixtures/test_new.png",
          filename: "test_new.png"
        })

      conn =
        put(
          conn |> put_req_header("content-type", "multipart/form-data"),
          Routes.user_organization_asset_path(@endpoint, :update, organization.id, asset_id),
          update_params
        )

      asset_json = json_response(conn, 200)

      assert_schema(asset_json, "Asset", Quantu.App.Web.ApiSpec.spec())
      assert asset_json["name"] == update_params["name"].filename
    end
  end

  describe "delete asset" do
    test "should delete asset", %{conn: conn, organization: organization} do
      %{id: asset_id} =
        OpenApiSpex.Schema.example(Schema.Asset.Create.schema())
        |> Util.underscore()
        |> Map.put("organization_id", organization.id)
        |> Map.put("name", %Plug.Upload{path: "test/fixtures/test.png", filename: "test.png"})
        |> Service.Asset.Create.new!()
        |> Service.Asset.Create.handle!()

      delete_conn =
        delete(
          conn,
          Routes.user_organization_asset_path(@endpoint, :delete, organization.id, asset_id)
        )

      response(delete_conn, 204)

      conn =
        get(
          conn,
          Routes.user_organization_asset_path(@endpoint, :show, organization.id, asset_id)
        )

      json_response(conn, 404)
    end
  end
end
