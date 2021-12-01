defmodule Quantu.App.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add(:organization_id, references(:organizations, on_delete: :delete_all, on_update: :nothing), null: false)
      add(:parent_id, references(:assets, on_delete: :nothing, on_update: :nothing), null: true)

      add(:name, :string, null: true)
      add(:type, :string, null: true)

      timestamps(type: :utc_datetime)
    end

    create(index(:assets, [:organization_id]))
    create(index(:assets, [:parent_id]))
    create(unique_index(:assets, [:organization_id, :parent_id, :name]))
  end
end
