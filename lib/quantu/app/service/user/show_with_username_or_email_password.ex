defmodule Quantu.App.Service.User.ShowWithUsernameOrEmailAndPassword do
  use Aicacia.Handler
  import Ecto.Changeset

  alias Quantu.App.{Model, Service, Repo}

  def no_match_error, do: "email or password does not match"

  @primary_key false
  schema "" do
    field(:username_or_email, :string)
    field(:password, :string)

    belongs_to(:user, Model.User, type: :binary_id)
    field(:email, :string)
    field(:username, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:username_or_email, :password])
    |> validate_required([:username_or_email, :password])
    |> validate_username_or_email()
    |> validate_username_or_email_and_password()
  end

  def handle(%{} = command) do
    Service.User.Show.handle(%{user_id: command.user_id})
  end

  def validate_username_or_email(changeset) do
    username_or_email = get_field(changeset, :username_or_email)

    if Service.Email.Create.email?(username_or_email) do
      put_change(changeset, :email, username_or_email)
    else
      put_change(changeset, :username, username_or_email)
    end
  end

  def validate_username_or_email_and_password(changeset) do
    case get_field(changeset, :email) do
      nil ->
        case get_field(changeset, :username) do
          nil ->
            validate_username_or_email_and_password_error(changeset)

          username ->
            case Repo.get_by(Model.User, username: username) do
              nil ->
                validate_username_or_email_and_password_error(changeset)

              user ->
                validate_username_or_email_and_password(changeset, user.id)
            end
        end

      email ->
        case Repo.get_by(Model.Email, email: email) do
          nil ->
            validate_username_or_email_and_password_error(changeset)

          email ->
            validate_username_or_email_and_password(changeset, email.user_id)
        end
    end
  end

  def validate_username_or_email_and_password(changeset, user_id) do
    case Service.User.Verify.new(%{
           user_id: user_id,
           password: get_field(changeset, :password)
         }) do
      {:ok, %{valid: true}} ->
        put_change(changeset, :user_id, user_id)

      _error ->
        validate_username_or_email_and_password_error(changeset)
    end
  end

  defp validate_username_or_email_and_password_error(changeset) do
    changeset
    |> add_error(:username_or_email, no_match_error())
    |> add_error(:password, no_match_error())
  end
end
