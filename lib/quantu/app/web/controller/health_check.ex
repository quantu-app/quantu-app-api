defmodule Quantu.App.Web.Controller.HealthCheck do
  use Quantu.App.Web, :controller
  use OpenApiSpex.ControllerSpecs

  alias Quantu.App.Web.Schema

  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)
  action_fallback(Quantu.App.Web.Controller.Fallback)

  tags ["Util"]

  operation :health,
    summary: "Health Check",
    description: "Returns simple json response to see if the server is up and running",
    responses: [
      ok: {"Health Check Response", "application/json", Schema.Util.HealthCheck}
    ]

  def health(conn, _params) do
    for repo <- Application.fetch_env!(:quantu_app, :ecto_repos) do
      repo.__adapter__.storage_up(repo.config)
    end

    conn
    |> json(%{ok: true})
  end
end
