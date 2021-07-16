defmodule Quantu.App.Repo.Migrations.CreateEmailConfirmationTokens do
  use Ecto.Migration

  def change do
    create table(:email_confirmation_tokens) do
      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:email_id, references(:emails, on_delete: :delete_all, on_update: :nothing), null: false)

      add(:confirmation_token, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:email_confirmation_tokens, [:user_id]))
    create(index(:email_confirmation_tokens, [:email_id]))
    create(unique_index(:email_confirmation_tokens, [:user_id, :email_id]))
  end
end
