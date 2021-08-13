defmodule Quantu.App.Web.Plug.Organization.Write do
  import Plug.Conn

  @behaviour Plug

  alias Quantu.App.{Guard, Web.Controller}

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn = %{params: %{"organization_id" => organization_id}}, _opts) do
    resource_user = Guardian.Plug.current_resource(conn)

    case Guard.Organization.Write.new(%{
           organization_id: organization_id,
           user_id: resource_user.id
         }) do
      {:ok, command} ->
        case Guard.Organization.Write.handle(command) do
          {:ok, _result} ->
            conn

          error_result ->
            Controller.Fallback.call(conn, error_result)
            |> halt()
        end

      error_result ->
        Controller.Fallback.call(conn, error_result)
        |> halt()
    end
  end
end
