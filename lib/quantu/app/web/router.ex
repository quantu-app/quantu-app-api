defmodule Quantu.App.Web.Router do
  use Quantu.App.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {Quantu.App.Web.View.Layout, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :upload do
    plug(:accepts, ["html", "json"])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth_access do
    plug(Quantu.App.Web.Guardian.AuthAccessPipeline)
  end

  pipeline :api_spec do
    plug(OpenApiSpex.Plug.PutApiSpec, module: Quantu.App.Web.ApiSpec)
  end

  scope "/swagger" do
    pipe_through(:browser)

    get("/", OpenApiSpex.Plug.SwaggerUI,
      path: "/swagger.json",
      default_model_expand_depth: 10,
      display_operation_id: true
    )
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/dashboard" do
      pipe_through(:browser)

      live_dashboard("/",
        metrics: Quantu.App.Web.Telemetry,
        ecto_repos: [Quantu.App.Repo]
      )
    end
  end

  scope "/" do
    pipe_through(:api)
    pipe_through(:api_spec)

    get("/swagger.json", OpenApiSpex.Plug.RenderSpec, [])

    scope "/", Quantu.App.Web.Controller do
      get("/health", HealthCheck, :health)
      head("/health", HealthCheck, :health)

      scope "/auth" do
        get("/:provider", Auth, :request)
        get("/:provider/callback", Auth, :callback)
        post("/sign-in", Auth.SignIn, :sign_in)
        post("/sign-up", Auth.SignUp, :sign_up)

        pipe_through(:auth_access)

        get("/", Auth, :current)
        delete("/", Auth, :delete)
      end

      pipe_through(:auth_access)

      scope "/user" do
        scope "/email", User do
          post("/", Email, :create)
          put("/confirm", Email, :confirm)
          patch("/confirm", Email, :confirm)
          put("/:id/primary", Email, :set_primary)
          patch("/:id/primary", Email, :set_primary)
          delete("/:id", Email, :delete)
        end

        scope "/username", User do
          put("/", Username, :update)
          patch("/", Username, :update)
        end

        scope "/password", User do
          put("/reset", Password, :reset)
          patch("/reset", Password, :reset)
        end

        scope "/deactivate", User do
          delete("/", Deactivate, :deactivate)
        end

        resources "/organizations", Organization, except: [:new, :edit]
      end

      get("/organizations/:url", Organization, :show_by_url)
    end
  end
end
