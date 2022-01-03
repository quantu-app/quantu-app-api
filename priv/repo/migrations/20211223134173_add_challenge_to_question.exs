defmodule Quantu.App.Repo.Migrations.AddChallengeToQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:is_challenge, :boolean, null: false, default: false)
      add(:released_at, :utc_datetime, null: true)
    end
  end
end
