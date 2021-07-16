defmodule Quantu.App.Service.Email.Create do
  use Aicacia.Handler

  alias Quantu.App.Model
  alias Quantu.App.Service
  alias Quantu.App.Repo

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:email, :string)
    field(:primary, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :email, :primary])
    |> validate_required([:user_id, :email])
    |> validate_format(:email, @email_regex)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:email)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email =
        %Model.Email{}
        |> cast(
          %{
            user_id: command.user_id,
            email: command.email,
            primary: Map.get(command, :primary, false)
          },
          [:user_id, :email, :primary]
        )
        |> foreign_key_constraint(:user_id)
        |> unique_constraint(:email)
        |> Repo.insert!()

      Service.Email.CreateConfirmationToken.handle!(%{user_id: email.user_id, email_id: email.id})

      email
    end)
  end

  def email?(string) when is_binary(string) do
    Regex.match?(@email_regex, string)
  end

  def email?(nil), do: false
end
