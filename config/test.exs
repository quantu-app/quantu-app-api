use Mix.Config

config :quantu_app, Quantu.App.Web.Endpoint,
  http: [port: 4002],
  server: false

config :quantu_app, Quantu.App.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, log_rounds: 1

config :cors_plug,
  origin: ~r/.*/
