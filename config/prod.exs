use Mix.Config

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "app-quantu-app.api"

config :quantu_app, Quantu.App.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30,
  hostname: "app-postgresql.api"
