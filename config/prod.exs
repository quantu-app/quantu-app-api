use Mix.Config

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "quantu-app-quantu-app-api.api"

config :waffle,
  storage: Waffle.Storage.S3,
  bucket: "quantu-app-assets",
  asset_host: "https://quantu-app-assets.us-southeast-1.linodeobjects.com/quantu-app-assets"

config :quantu_app, Quantu.App.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30,
  hostname: "quantu-app-postgresql.api"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id:
    System.get_env("FACEBOOK_CLIENT_ID") ||
         raise("""
         environment variable FACEBOOK_CLIENT_ID is missing.
         You can generate one by calling: mix phx.gen.secret
         """)),
  client_secret:
    System.get_env("FACEBOOK_CLIENT_SECRET") ||
         raise("""
         environment variable FACEBOOK_CLIENT_SECRET is missing.
         You can generate one by calling: mix phx.gen.secret
         """))
