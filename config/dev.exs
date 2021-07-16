use Mix.Config

config :quantu_app, Quantu.App.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :bcrypt_elixir, log_rounds: 1
