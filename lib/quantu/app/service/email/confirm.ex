defmodule Quantu.App.Service.Email.Confirm do
  use Aicacia.Handler

  alias Quantu.App.Model
  alias Quantu.App.Repo

  def invalid_confirmation_token, do: "invalid confirmation token"

  @primary_key false
  schema "" do
    field(:confirmation_token, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:confirmation_token])
    |> validate_required([:confirmation_token])
    |> validate_confirmation_token()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email_confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, confirmation_token: command.confirmation_token)

      email =
        Repo.get_by!(Model.Email,
          id: email_confirmation_token.email_id,
          user_id: email_confirmation_token.user_id
        )
        |> cast(
          %{confirmed: true},
          [:confirmed]
        )
        |> Repo.update!()

      Repo.delete!(email_confirmation_token)

      email
    end)
  end

  def validate_confirmation_token(changeset) do
    case get_field(changeset, :confirmation_token) do
      nil ->
        add_error(changeset, :confirmation_token, invalid_confirmation_token())

      confirmation_token ->
        case Repo.get_by(Model.EmailConfirmationToken, confirmation_token: confirmation_token) do
          nil ->
            add_error(changeset, :confirmation_token, invalid_confirmation_token())

          _email_confirmation_token ->
            changeset
        end
    end
  end
end
