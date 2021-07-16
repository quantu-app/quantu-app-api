defmodule Quantu.App.Service.User.Reset do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.Model
  alias Quantu.App.Service
  alias Quantu.App.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:old_password, :string)
    field(:password, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :old_password, :password])
    |> validate_required([:user_id, :old_password, :password])
    |> foreign_key_constraint(:user_id)
    |> Service.User.Create.encrypt_password()
    |> validate_password_not_current()
    |> validate_password_not_already_used()
    |> validate_old_password()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.user_id)
      |> cast(
        %{encrypted_password: command.encrypted_password},
        [:encrypted_password]
      )
      |> Repo.update!()
      |> Repo.preload([:emails])
    end)
  end

  def validate_old_password(changeset) do
    case Repo.get!(Model.User, get_field(changeset, :user_id)) do
      nil ->
        add_error(changeset, :old_password, "old password does not match")

      %Model.User{encrypted_password: encrypted_password} ->
        case Bcrypt.verify_pass(
               get_field(changeset, :old_password, ""),
               encrypted_password
             ) do
          true ->
            changeset

          false ->
            add_error(changeset, :old_password, "old password does not match")
        end
    end
  end

  def validate_password_not_current(changeset) do
    user_id = get_field(changeset, :user_id)
    password = get_field(changeset, :password)

    case Repo.get!(
           Model.User,
           user_id
         ) do
      nil ->
        changeset

      %Model.User{encrypted_password: encrypted_password} ->
        if Bcrypt.verify_pass(password, encrypted_password) do
          add_error(changeset, :password, "cannot be current password")
        else
          changeset
        end
    end
  end

  def validate_password_not_already_used(changeset) do
    user_id = get_field(changeset, :user_id)

    case from(p in Model.OldPassword,
           where: p.user_id == ^user_id,
           limit: 6,
           order_by: [asc: p.inserted_at]
         )
         |> Repo.all() do
      [] ->
        changeset

      old_passwords ->
        validate_password_not_already_used(changeset, old_passwords, 0)
    end
  end

  defp validate_password_not_already_used(changeset, old_passwords, index) do
    case Enum.at(old_passwords, index) do
      nil ->
        changeset

      old_password ->
        password = get_field(changeset, :password)

        if Bcrypt.verify_pass(password, old_password.encrypted_password) do
          add_error(changeset, :password, "cannot be one of old passwords")
        else
          validate_password_not_already_used(changeset, old_passwords, index + 1)
        end
    end
  end
end
