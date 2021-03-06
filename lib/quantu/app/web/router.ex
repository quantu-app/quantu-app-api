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
    plug(:accepts, ["json", "multipart"])
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

  pipeline :organization_write do
    plug Quantu.App.Web.Plug.Organization.Write
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
    pipe_through(:api_spec)
    pipe_through(:api)

    get("/swagger.json", OpenApiSpex.Plug.RenderSpec, [])

    scope "/", Quantu.App.Web.Controller do
      get("/health", HealthCheck, :health)
      head("/health", HealthCheck, :health)

      get("/static/assets/:organization_id/:parent_id/:id", Asset, :show_by_parent)
      get("/static/assets/:organization_id/:id", Asset, :show_by_organization)

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

      resources "/users", User, only: [:show]
      put("/user", User, :update)
      patch("/user", User, :update)

      scope "/user", User, as: :user do
        scope "/email" do
          post("/", Email, :create)
          put("/confirm", Email, :confirm)
          patch("/confirm", Email, :confirm)
          put("/:id/primary", Email, :set_primary)
          patch("/:id/primary", Email, :set_primary)
          delete("/:id", Email, :delete)
        end

        scope "/username" do
          put("/", Username, :update)
          patch("/", Username, :update)
        end

        scope "/password" do
          put("/reset", Password, :reset)
          patch("/reset", Password, :reset)
        end

        resources "/organizations", Organization, except: [:new, :edit] do
          pipe_through(:organization_write)

          scope "/" do
            pipe_through(:upload)
            resources "/assets", Asset, except: [:new, :edit]
          end

          resources "/courses", Course, except: [:new, :edit]
          resources "/units", Unit, except: [:new, :edit]
          get("/units/:id/children", Unit, :children)
          resources "/lessons", Lesson, except: [:new, :edit]
          resources "/quizzes", Quiz, except: [:new, :edit]
          post("/quizzes/:id/add-questions", Quiz, :add_questions)
          post("/quizzes/:id/remove-questions", Quiz, :remove_questions)
          resources "/questions", Question, except: [:new, :edit]
        end
      end

      resources "/organizations", Organization, only: [:index, :show]
      resources "/courses", Course, only: [:index, :show]
      resources "/units", Unit, only: [:index, :show]
      get("/units/:id/children", Unit, :children)
      resources "/lessons", Lesson, only: [:index, :show]
      post("/questions/:id/answer", Question, :answer)
      post("/questions/:id/explain", Question, :explain)
      resources "/quizzes", Quiz, only: [:index, :show]
      resources "/questions", Question, only: [:index, :show]
      resources "/question-results", QuestionResult, only: [:index, :show]

      get("/organization/:url", Organization, :show_by_url)
    end
  end
end
