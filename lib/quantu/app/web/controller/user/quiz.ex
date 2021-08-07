defmodule Quantu.App.Web.Controller.User.Quiz do
  @moduledoc tags: ["User", "Quiz"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.{Service, Util}
  alias Quantu.App.Web.{Schema, View}

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  List Quizzes

  Returns organization's quizzes
  """
  @doc responses: [
         ok: {"Organization Quizzes", "application/json", Schema.Quiz.List}
       ],
       parameters: [
         organizationId: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def index(conn, params) do
    with {:ok, command} <- Service.Quiz.Index.new(params),
         {:ok, quizzes} <- Service.Quiz.Index.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("index.json", quizzes: quizzes)
    end
  end

  @doc """
  Get a Quiz

  Returns organization's quiz
  """
  @doc responses: [
         ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
       ],
       parameters: [
         id: [in: :path, description: "Quiz Id", type: :string, example: "1001"],
         organizationId: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def show(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Show.new(%{
             quiz_id: Map.get(params, "id"),
             organization_id: Map.get(params, "organization_id")
           }),
         {:ok, quiz} <- Service.Quiz.Show.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  @doc """
  Create a Quiz

  Returns organization's created quiz
  """
  @doc request_body:
         {"Request body to create quiz", "application/json", Schema.Quiz.Create, required: true},
       responses: [
         ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
       ],
       parameters: [
         organizationId: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def create(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Create.new(Util.underscore(params)),
         {:ok, quiz} <- Service.Quiz.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  @doc """
  Updates a Quiz

  Returns organization's updated quiz
  """
  @doc request_body:
         {"Request body to update quiz", "application/json", Schema.Quiz.Update, required: true},
       responses: [
         ok: {"Organization Quiz", "application/json", Schema.Quiz.Show}
       ],
       parameters: [
         id: [in: :path, description: "Quiz Id", type: :string, example: "1001"],
         organizationId: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def update(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Update.new(
             Map.merge(Util.underscore(params), %{
               "quiz_id" => Map.get(params, "id")
             })
           ),
         {:ok, quiz} <- Service.Quiz.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Quiz)
      |> render("show.json", quiz: quiz)
    end
  end

  @doc """
  Delete a Quiz

  Returns nothing
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       parameters: [
         id: [in: :path, description: "Quiz Id", type: :string, example: "1001"],
         organizationId: [
           in: :path,
           description: "Organization Id",
           type: :string,
           example: "1001"
         ]
       ]
  def delete(conn, params) do
    with {:ok, command} <-
           Service.Quiz.Delete.new(%{
             quiz_id: Map.get(params, "id")
           }),
         {:ok, _} <- Service.Quiz.Delete.handle(command) do
      send_resp(conn, :no_content, "")
    end
  end
end
