defmodule Quantu.App.Repo.Migrations.InitalSeeds do
  use Ecto.Migration

  alias Quantu.App.Repo

  def up do
    Repo.transaction(fn ->
      nil
    end)
  end
end
