defmodule Quantu.App.Web.Controller.HealthCheck do
  @moduledoc tags: ["Util"]

  use Quantu.App.Web, :controller
  use OpenApiSpex.Controller

  alias Quantu.App.Web.Schema

  action_fallback(Quantu.App.Web.Controller.Fallback)

  @doc """
  Health Check

  Returns simple json response to see if the server is up and running
  """
  @doc responses: [
         ok: {"Health Check Response", "application/json", Schema.Util.HealthCheck}
       ]
  def health(conn, _params) do
    conn
    |> json(%{ok: true})
  end
end
