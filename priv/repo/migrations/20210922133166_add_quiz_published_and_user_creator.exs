defmodule Quantu.App.Repo.Migrations.AddQuizPublishedAndUserCreator do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:creator, :boolean, null: false, default: false)
    end

    alter table(:quizzes) do
      add(:published, :boolean, null: false, default: false)
    end
  end
end
