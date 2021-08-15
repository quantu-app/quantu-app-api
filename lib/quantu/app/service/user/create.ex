defmodule Quantu.App.Service.User.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @username_regex ~r/[a-zA-Z0-9\-_]+/i

  def username_regex, do: @username_regex

  @primary_key false
  schema "" do
    field(:username, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_required([:username, :password])
    |> validate_format(:username, @username_regex)
    |> validate_length(:password, min: 8)
    |> encrypt_password()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.User{}
      |> cast(command, [:username, :encrypted_password])
      |> unique_constraint(:username)
      |> Repo.insert!()
      |> Repo.preload([:emails])
    end)
  end

  def encrypt_password(changeset) do
    case get_field(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
