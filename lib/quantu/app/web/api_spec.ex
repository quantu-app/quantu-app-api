defmodule Quantu.App.Web.ApiSpec do
  @behaviour OpenApiSpex.OpenApi

  @impl OpenApiSpex.OpenApi
  def spec,
    do:
      %OpenApiSpex.OpenApi{
        servers: [
          OpenApiSpex.Server.from_endpoint(Quantu.App.Web.Endpoint),
          %OpenApiSpex.Server{
            url: "https://api.quantu.app"
          }
        ],
        info: %OpenApiSpex.Info{
          title: Application.spec(:quantu_app, :description) |> to_string(),
          version: Application.spec(:quantu_app, :vsn) |> to_string()
        },
        paths: OpenApiSpex.Paths.from_router(Quantu.App.Web.Router),
        components: %OpenApiSpex.Components{
          securitySchemes: %{
            "authorization" => %OpenApiSpex.SecurityScheme{
              type: "http",
              scheme: "bearer",
              bearerFormat: "JWT",
              in: "header"
            }
          }
        }
      }
      |> OpenApiSpex.resolve_schema_modules()
end
