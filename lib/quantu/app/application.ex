defmodule Quantu.App.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      Quantu.App.Repo,
      Quantu.App.Web.Telemetry,
      {Guardian.DB.Token.SweeperServer, []},
      {Phoenix.PubSub, name: Quantu.App.PubSub},
      Quantu.App.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Quantu.App.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Quantu.App.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
