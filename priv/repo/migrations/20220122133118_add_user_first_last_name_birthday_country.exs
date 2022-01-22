defmodule Quantu.App.Repo.Migrations.AddUserFirstLastNameBirthdayCountry do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:birthday, :date)
      add(:country, :string)
      modify(:active, :boolean, default: false, null: false)
    end
  end
end
