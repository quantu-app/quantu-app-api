defmodule Quantu.App.MixProject do
  use Mix.Project

  def organization, do: :quantu

  def name, do: :app

  def version, do: "0.1.0"

  def project,
    do: [
      app: String.to_atom("#{organization()}_#{name()}"),
      version: version(),
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]

  def application,
    do: [
      mod: {Quantu.App.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps,
    do: [
      {:phoenix, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_view, "~> 0.15"},
      {:phoenix_live_dashboard, "~> 0.4", like: [:dev, :test]},
      {:floki, "~> 0.31", only: :test},
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0"},
      {:ex_aws, "~> 2.2"},
      {:ex_aws_s3, "~> 2.2"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5"},
      {:aicacia_handler, "~> 0.1"},
      {:ecto_sql, "~> 3.6"},
      {:ecto_psql_extras, "~> 0.6", only: :dev},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:cors_plug, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:peerage, "~> 1.0"},
      {:bcrypt_elixir, "~> 2.3"},
      {:ueberauth, "~> 0.7"},
      {:guardian, "~> 2.1"},
      {:guardian_db, "~> 2.1"},
      {:guardian_phoenix, "~> 2.0"},
      {:open_api_spex, "~> 3.10"},
      {:excoveralls, "~> 0.14", only: :test}
    ]

  defp namespace(), do: "api"
  defp helm_dir(), do: "./helm/#{organization()}-#{name()}"

  defp docker_repository(), do: "registry.gitlab.com/quantu/ex-id"
  defp docker_tag(), do: "#{docker_repository()}:#{version()}"

  defp helm_overrides(),
    do:
      "--set image.tag=#{version()} --set image.repository=#{docker_repository()} --set image.hash=$(mix docker.sha256)"

  defp createHelmInstall(values \\ nil),
    do:
      "helm install #{helm_dir()} --name #{name()} --namespace=#{namespace()} #{helm_overrides()} #{
        if values == nil, do: "", else: "--values #{values}"
      }"

  defp createHelmUpgrade(values \\ nil),
    do:
      "helm upgrade #{name()} #{helm_dir()} --namespace=#{namespace()} --install #{
        helm_overrides()
      } #{if values == nil, do: "", else: "--values #{values}"}"

  defp aliases,
    do: [
      # Dev Postgres
      postgres: [
        "cmd docker run --rm -d " <>
          "--name #{name()}-postgres " <>
          "-e POSTGRES_PASSWORD=postgres " <>
          "-p 5432:5432 " <>
          "postgres:13-alpine"
      ],
      "postgres.delete": [
        "cmd docker rm -f #{name()}-postgres"
      ],

      # Database
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],

      # Docker
      "docker.build": ["cmd docker build --build-arg MIX_ENV=#{Mix.env()} -t #{docker_tag()} ."],
      "docker.push": ["cmd docker push #{docker_tag()}"],
      "docker.sha256": [
        ~s(cmd docker inspect --format='"{{index .Id}}"' #{docker_tag()})
      ],
      "docker.run": [
        "cmd docker run --name #{name()} --network=host " <>
          "-e DATABASE_HOST=$DATABASE_HOST " <>
          " -e SECRET_KEY_BASE=$SECRET_KEY_BASE " <>
          " -e GUARDIAN_TOKEN=$GUARDIAN_TOKEN " <>
          " -e MIX_ENV=#{Mix.env()} " <>
          "-p 4000:4000 #{docker_tag()}"
      ],
      "docker.delete": ["cmd docker rm -f #{name()}"],

      # Helm
      "helm.delete": ["cmd helm delete --namespace #{namespace()} #{name()}"],
      "helm.install": ["cmd #{createHelmInstall()}"],
      "helm.install.local": ["cmd #{createHelmInstall("#{helm_dir()}/values-local.yaml")}"],
      "helm.upgrade": ["cmd #{createHelmUpgrade()}"],
      "helm.upgrade.local": ["cmd #{createHelmUpgrade("#{helm_dir()}/values-local.yaml")}"],
      helm: [
        "docker.build",
        "docker.push",
        "helm.upgrade"
      ],
      "helm.local": [
        "docker.build",
        "docker.push",
        "helm.upgrade.local"
      ]
    ]
end
