defmodule Quantu.App.Web.Guardian.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :quantu_app

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, refresh_from_cookie: false)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
