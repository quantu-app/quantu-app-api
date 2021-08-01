defmodule Quantu.App.Web.ApiSpec do
  @behaviour OpenApiSpex.OpenApi

  @impl OpenApiSpex.OpenApi
  def spec,
    do:
      %OpenApiSpex.OpenApi{
        servers: [
          OpenApiSpex.Server.from_endpoint(Quantu.App.Web.Endpoint),
          "https://api.app.quantu.com"
        ],
        info: %OpenApiSpex.Info{
          title: Application.spec(:quantu_app, :description) |> to_string(),
          version: Application.spec(:quantu_app, :vsn) |> to_string()
        },
        paths: OpenApiSpex.Paths.from_router(Quantu.App.Web.Router),
        components: %OpenApiSpex.Components{
          securitySchemes: %{
            "authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}
          }
        }
      }
      |> OpenApiSpex.resolve_schema_modules()
end
