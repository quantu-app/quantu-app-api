defmodule Quantu.App.Web.Controller.DocumentTest do
  use Quantu.App.Web.Case

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.Guardian

  setup %{conn: conn} do
    user =
      Service.User.Create.new!(%{
        username: "username",
        password: "password",
        password_confirmation: "password"
      })
      |> Service.User.Create.handle!()

    {:ok,
     user: user,
     conn:
       conn
       |> Guardian.Plug.sign_in(user)
       |> put_req_header("accept", "application/json")}
  end

  describe "get index/show" do
    test "should return list of documents", %{conn: conn, user: user} do
      %{id: document_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Document.Create.new!()
        |> Service.Document.Create.handle!()

      conn =
        get(
          conn,
          Routes.document_path(@endpoint, :index)
        )

      documents_json = json_response(conn, 200)

      assert Enum.at(documents_json, 0)["id"] == document_id
    end

    test "should return a document", %{conn: conn, user: user} do
      %{id: document_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Document.Create.new!()
        |> Service.Document.Create.handle!()

      conn =
        get(
          conn,
          Routes.document_path(@endpoint, :show, document_id)
        )

      document_json = json_response(conn, 200)

      assert document_json["id"] == document_id
    end
  end

  describe "create document" do
    test "should return created document", %{conn: conn, user: user} do
      create_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)

      conn =
        post(
          conn,
          Routes.document_path(@endpoint, :create),
          create_params
        )

      document_json = json_response(conn, 201)

      assert document_json["name"] == create_params["name"]
    end
  end

  describe "update document" do
    test "should return updated document", %{conn: conn, user: user} do
      %{id: document_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Document.Create.new!()
        |> Service.Document.Create.handle!()

      update_params = OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Update.schema())

      conn =
        put(
          conn,
          Routes.document_path(@endpoint, :update, document_id),
          update_params
        )

      document_json = json_response(conn, 200)

      assert document_json["name"] == update_params["name"]
    end
  end

  describe "upload document document" do
    test "should return updated document", %{conn: conn, user: user} do
      %{id: document_id} =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Create.schema())
        |> Util.underscore()
        |> Map.put("user_id", user.id)
        |> Service.Document.Create.new!()
        |> Service.Document.Create.handle!()

      update_params =
        OpenApiSpex.Schema.example(Quantu.App.Web.Schema.Document.Upload.schema())
        |> Map.put("url", %Plug.Upload{
          path: "test/fixtures/test.doc",
          filename: "test.doc"
        })

      upload_conn =
        post(
          conn,
          Routes.document_path(@endpoint, :upload, document_id),
          update_params
        )

      json_response(upload_conn, 200)

      download_conn =
        get(
          conn,
          Routes.document_path(@endpoint, :download, document_id)
        )

      response(download_conn, 200)
    end
  end
end
