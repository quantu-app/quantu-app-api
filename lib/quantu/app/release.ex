defmodule Quantu.App.Release do
  def setup do
    load_app()

    for repo <- repos() do
      repo.__adapter__.storage_up(repo.config)
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(:quantu_app, :ecto_repos)
  end

  defp load_app do
    Application.load(:quantu_app)
  end
end
