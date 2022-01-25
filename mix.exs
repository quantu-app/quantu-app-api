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
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_live_dashboard, "~> 0.6", like: [:dev, :test]},
      {:floki, "~> 0.32", only: :test},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:aicacia_handler, "~> 0.1"},
      {:decimal, "~> 2.0"},
      {:ecto_sql, "~> 3.7"},
      {:ecto_psql_extras, "~> 0.7", only: :dev},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.19"},
      {:jason, "~> 1.3"},
      {:cors_plug, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:peerage, "~> 1.0"},
      {:bcrypt_elixir, "~> 3.0"},
      {:guardian, "~> 2.2"},
      {:guardian_db, "~> 2.1"},
      {:guardian_phoenix, "~> 2.0"},
      {:ueberauth, "~> 0.7"},
      {:ueberauth_google, "~> 0.10"},
      {:ueberauth_facebook, "~> 0.9"},
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0"},
      {:ex_aws, "~> 2.2"},
      {:ex_aws_s3, "~> 2.3"},
      {:hackney, "~> 1.18"},
      {:sweet_xml, "~> 0.7"},
      {:mime, "~> 2.0"},
      {:open_api_spex, "~> 3.11"},
      {:excoveralls, "~> 0.14", only: :test}
    ]

  defp namespace(), do: "api"
  defp helm_dir(), do: "./helm/#{organization()}-#{name()}-api"

  defp docker_repository(),
    do: "docker.pkg.github.com/quantu-app/app-api/quantu-app-api"

  defp docker_tag(), do: "#{docker_repository()}:#{version()}"

  defp helm_overrides(),
    do:
      "--set image.tag=#{version()}" <>
        " --set image.repository=#{docker_repository()}" <>
        " --set image.hash=$(mix docker.sha256)" <>
        " --set env.SECRET_KEY_BASE=#{System.get_env("SECRET_KEY_BASE")}" <>
        " --set env.GUARDIAN_TOKEN=#{System.get_env("GUARDIAN_TOKEN")}" <>
        " --set env.GOOGLE_CLIENT_ID=#{System.get_env("GOOGLE_CLIENT_ID")}" <>
        " --set env.GOOGLE_CLIENT_SECRET=#{System.get_env("GOOGLE_CLIENT_SECRET")}" <>
        " --set-string env.FACEBOOK_CLIENT_ID=#{System.get_env("FACEBOOK_CLIENT_ID")}" <>
        " --set env.FACEBOOK_CLIENT_SECRET=#{System.get_env("FACEBOOK_CLIENT_SECRET")}" <>
        " --set env.S3_ACCESS_KEY_ID=#{System.get_env("S3_ACCESS_KEY_ID")}" <>
        " --set env.S3_SECRET_ACCESS_KEY=#{System.get_env("S3_SECRET_ACCESS_KEY")}"

  defp create_helm_upgrade(),
    do:
      "helm upgrade #{organization()}-#{name()} #{helm_dir()} -n=#{namespace()} --install #{helm_overrides()}"

  defp aliases,
    do: [
      # Dev Postgres
      postgres: [
        "cmd docker run --rm -d " <>
          "--name #{organization()}-#{name()}-postgres " <>
          "-e POSTGRES_PASSWORD=postgres " <>
          "-p 5432:5432 " <>
          "postgres:13-alpine"
      ],
      "postgres.delete": [
        "cmd docker rm -f #{organization()}-#{name()}-postgres"
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
        "cmd docker run --rm --name #{organization()}-#{name()}" <>
          " --network=host" <>
          " -e SECRET_KEY_BASE=$SECRET_KEY_BASE" <>
          " -e GUARDIAN_TOKEN=$GUARDIAN_TOKEN" <>
          " -e MIX_ENV=#{Mix.env()}" <>
          " #{docker_tag()}"
      ],
      "docker.stop": ["cmd docker rm -f #{organization()}-#{name()}"],

      # Helm
      "helm.delete": ["cmd helm delete --namespace #{namespace()} #{organization()}-#{name()}"],
      "helm.upgrade": ["cmd #{create_helm_upgrade()}"],
      helm: [
        "docker.build",
        "docker.push",
        "helm.upgrade"
      ]
    ]
end
