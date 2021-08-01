defmodule Quantu.App.Web.Controller.Question do
  @moduledoc tags: ["Question"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Questions

  Returns organization's questions
  """
  @doc responses: [
         ok: {"Organization Questions", "application/json", Schema.Question.List}
       ]
  def index(conn, _params) do
    resource_organization = Guardian.Plug.current_resource(conn)

    with {:ok, command} <- Service.Question.Index.new(%{organization_id: resource_organization.id}),
         {:ok, questions} <- Service.Question.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("index.json", questions: questions)
    end
  end

  @doc """
  Get a Question

  Returns organization's question
  """
  @doc responses: [
         ok: {"Organization Question", "application/json", Schema.Question.Show}
       ],
       parameters: [
         id: [in: :path, description: "Question Id", type: :string, example: "1001"]
       ]
  def show(conn, params) do
    resource_organization = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Show.new(%{question_id: params["id"], organization_id: resource_organization.id}),
         {:ok, question} <- Service.Question.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show.json", question: question)
    end
  end

  @doc """
  Get a Question by url

  Returns organization's question
  """
  @doc responses: [
    ok: {"Organization Question", "application/json", Schema.Question.Show}
  ],
  parameters: [
    url: [in: :path, description: "Question's url", type: :string, example: "QuantU"]
  ]
  def show_by_url(conn, params) do
    with {:ok, command} <-
          Service.Question.ShowByUrl.new(params),
        {:ok, question} <- Service.Question.ShowByUrl.handle(command) do
    conn
    |> put_status(200)
    |> put_view(View.Question)
    |> render("show.json", question: question)
    end
  end

  @doc """
  Create a Question

  Returns organization's created question
  """
  @doc request_body:
         {"Request body to create question", "application/json", Schema.Question.Create,
          required: true},
       responses: [
         ok: {"Organization Question", "application/json", Schema.Question.Show}
       ]
  def create(conn, params) do
    resource_organization = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Create.new(
             Map.merge(Util.underscore(params), %{"organization_id" => resource_organization.id})
           ),
         {:ok, question} <- Service.Question.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Question)
      |> render("show.json", question: question)
    end
  end

  @doc """
  Updates a Question

  Returns organization's updated question
  """
  @doc request_body:
         {"Request body to update question", "application/json", Schema.Question.Update,
          required: true},
       responses: [
         ok: {"Organization Question", "application/json", Schema.Question.Show}
       ],
       parameters: [
         id: [in: :path, description: "Question Id", type: :string, example: "1001"]
       ]
  def update(conn, params) do
    resource_organization = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Update.new(
             Map.merge(Util.underscore(params), %{
               "question_id" => Map.get(params, "id"),
               "organization_id" => resource_organization.id
             })
           ),
         {:ok, question} <- Service.Question.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Question)
      |> render("show.json", question: question)
    end
  end

  @doc """
  Delete a Question

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Question Id", type: :string, example: "1001"]
       ]
  def delete(conn, params) do
    resource_organization = Guardian.Plug.current_resource(conn)

    with {:ok, command} <-
           Service.Question.Delete.new(%{question_id: params["id"], organization_id: resource_organization.id}),
         {:ok, _} <- Service.Question.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
