defmodule Quantu.App.Service.Email.CreateConfirmationToken do
  use Aicacia.Handler

  alias Quantu.App.Model
  alias Quantu.App.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :email_id])
    |> validate_required([:user_id, :email_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:email_id)
    |> unique_constraint(:email_id,
      name: :email_confirmation_token_user_id_email_id_index
    )
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.EmailConfirmationToken{}
      |> cast(
        %{
          user_id: command.user_id,
          email_id: command.email_id,
          confirmation_token: Quantu.App.Util.generate_token(64)
        },
        [:user_id, :email_id, :confirmation_token]
      )
      |> Repo.insert!()
    end)
  end
end
