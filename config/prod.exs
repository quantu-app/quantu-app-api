use Mix.Config

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "quantu-app-quantu-app-api.api"

config :waffle,
  storage: Waffle.Storage.S3,
  bucket: "quantu-app-assets"

config :quantu_app, Quantu.App.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30,
  hostname: "quantu-app-postgresql.api"
