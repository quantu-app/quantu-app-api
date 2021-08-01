defmodule Quantu.App.Service.User.FromUeberauth do
  import Ecto.Changeset

  alias Quantu.App.{Util, Repo, Model, Service}
  alias Ueberauth.Auth

  def from_ueberauth(%Auth{} = auth) do
    Repo.run(fn ->
      email = email_from_auth(auth)

      case(
        case Repo.get_by(Model.Email, email: email_from_auth(auth), confirmed: true) do
          nil ->
            nil

          %Model.Email{user_id: user_id} ->
            case Repo.get_by(Model.User, id: user_id, username: email) do
              nil ->
                nil

              _user ->
                Service.User.Show.get_user!(user_id)
            end
        end
      ) do
        nil ->
          create_user!(email)

        user ->
          user
      end
    end)
  end

  def create_user!(email) do
    %Model.User{id: user_id} =
      Service.User.Create.new!(%{
        username: email,
        password: Util.generate_token(64)
      })
      |> Service.User.Create.handle!()

    %Model.Email{}
    |> cast(
      %{
        user_id: user_id,
        email: email,
        primary: true,
        confirmed: true
      },
      [:user_id, :email, :primary, :confirmed]
    )
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:email)
    |> Repo.insert!()

    Service.User.Show.get_user!(user_id)
  end

  def email_from_auth(%Auth{info: %Auth.Info{email: email}}) when is_binary(email),
    do: email

  def email_from_auth(_auth), do: nil
end
