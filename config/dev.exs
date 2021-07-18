use Mix.Config

config :quantu_app, Quantu.App.Web.Endpoint,
  debug_errors: true,
  code_reloader: true

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :bcrypt_elixir, log_rounds: 1

config :cors_plug,
  origin: ~r/.*/
