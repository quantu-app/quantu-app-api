use Mix.Config

config :quantu_app,
  generators: [binary_id: true],
  ecto_repos: [Quantu.App.Repo]

config :quantu_app, Quantu.App.Web.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  check_origin: false,
  secret_key_base:
    System.get_env("SECRET_KEY_BASE") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable SECRET_KEY_BASE is missing.
         You can generate one by calling: mix phx.gen.secret
         """)),
  render_errors: [
    view: Quantu.App.Web.View.Error,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: Quantu.App.PubSub,
  live_view: [signing_salt: "ozGtcOcL"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "localhost",
  app_name: "quantu_app"

config :cors_plug,
  origin: ~r/https.*quantu.app$/

config :bcrypt_elixir, log_rounds: 12

config :quantu_app, Quantu.App.Web.Guardian,
  issuer: "quantu_app",
  secret_key:
    System.get_env("GUARDIAN_TOKEN") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable GUARDIAN_TOKEN is missing.
         You can generate one by calling: mix guardian.gen.secret
         """))

config :quantu_app, Quantu.App.Web.Guardian.AuthAccessPipeline,
  module: Quantu.App.Web.Guardian,
  error_handler: Quantu.App.Web.Guardian.ErrorHandler

config :guardian, Guardian.DB,
  repo: Quantu.App.Repo,
  token_types: ["refresh_token"],
  schema_name: "tokens",
  sweep_interval: 60

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id:
    System.get_env("GOOGLE_CLIENT_ID") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable GOOGLE_CLIENT_ID is missing.
         You can generate one by calling: mix phx.gen.secret
         """)),
  client_secret:
    System.get_env("GOOGLE_CLIENT_SECRET") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable GOOGLE_CLIENT_SECRET is missing.
         You can generate one by calling: mix phx.gen.secret
         """))

config :quantu_app, Quantu.App.Repo,
  username: "postgres",
  password: "postgres",
  database: "quantu_app_#{Mix.env()}",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true

config :ex_aws,
  json_codec: Jason,
  access_key_id: [
    System.get_env("AWS_ACCESS_KEY_ID") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable AWS_ACCESS_KEY_ID is missing.
         You can generate one by calling: mix phx.gen.secret
         """)),
    :instance_role
  ],
  secret_access_key: [
    System.get_env("AWS_SECRET_ACCESS_KEY") ||
      (Mix.env() == "prod" &&
         raise("""
         environment variable AWS_SECRET_ACCESS_KEY is missing.
         You can generate one by calling: mix phx.gen.secret
         """)),
    :instance_role
  ]

config :waffle,
  storage: Waffle.Storage.Local

import_config "#{Mix.env()}.exs"
