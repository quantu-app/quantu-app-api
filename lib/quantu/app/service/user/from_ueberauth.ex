defmodule Quantu.App.Service.User.FromUeberauth do
  import Ecto.Changeset

  alias Quantu.App.{Util, Repo, Model, Service}
  alias Ueberauth.Auth

  def from_ueberauth(%Auth{} = auth) do
    Repo.run(fn ->
      email = email_from_auth(auth)

      case(
        case Repo.get_by(Model.Email, email: email, confirmed: true) do
          nil ->
            nil

          %Model.Email{user_id: user_id} ->
            case Repo.get(Model.User, user_id) do
              nil ->
                nil

              _user ->
                Service.User.Show.get_user!(user_id)
            end
        end
      ) do
        nil ->
          create_user!(
            email,
            username_from_auth(auth, email),
            first_last_name_from_auth(auth),
            birthday_from_auth(auth)
          )

        user ->
          user
      end
    end)
  end

  def create_user!(email, username, [first_name, last_name], birthday) do
    %Model.User{id: user_id} =
      Service.User.Create.new!(%{
        username: unique_username(username),
        password: Util.generate_token(64),
        first_name: first_name,
        last_name: last_name,
        birthday: birthday
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

  def unique_username(nil), do: nil

  def unique_username(username) when is_binary(username) do
    case Repo.get_by(Model.User, username: username) do
      nil ->
        username

      %Model.User{} ->
        unique_username(username <> Util.generate_token(4))
    end
  end

  def email_to_username(email), do: Regex.replace(~r/@.*$/, email, "")

  def email_from_auth(%Auth{info: %Auth.Info{email: email}}) when is_binary(email),
    do: email

  def email_from_auth(_auth), do: nil

  def username_from_auth(%Auth{info: %Auth.Info{nickname: nickname}}, _email)
      when is_binary(nickname),
      do: nickname

  def username_from_auth(_auth, email) when is_binary(email),
    do: Regex.replace(~r/@.*$/, email, "")

  def username_from_auth(_auth, _email),
    do: nil

  def first_last_name_from_auth(%Auth{info: %Auth.Info{} = info}) do
    if info.name do
      names = Enum.map(String.split(info.name, ~r"\s+"), &String.trim/1)
      [List.first(names), List.last(names)]
    else
      [info.first_name, info.last_name]
    end
  end

  def first_last_name_from_auth(_auth), do: [nil, nil]

  def birthday_from_auth(%Auth{info: %Auth.Info{} = info}), do: info.birthday
  def birthday_from_auth(_auth), do: nil
end
