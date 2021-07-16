defmodule Quantu.App.Service.User.FromUeberauth do
  alias Quantu.App.Util
  alias Ueberauth.Auth

  def from_ueberauth!(_auth), do: {:error, :unsupported}

  def username_from_auth(%Auth{} = auth) do
    username =
      cond do
        not Util.blank?(username_from_credentials(auth.credentials)) ->
          username_from_credentials(auth.credentials)

        not Util.blank?(auth.info.nickname) ->
          auth.info.nickname

        not Util.blank?(auth.info.name) ->
          auth.info.name

        true ->
          name =
            [auth.info.first_name, auth.info.last_name]
            |> Enum.filter(&(&1 != nil and &1 != ""))
            |> Enum.join()

          if Util.blank?(name) do
            nil
          else
            name
          end
      end

    if Util.blank?(username) do
      nil
    else
      String.replace(username, ~r/[^\w]+/, "")
    end
  end

  defp username_from_credentials(%Auth.Credentials{other: %{username: username}}),
    do: username

  defp username_from_credentials(%Auth.Credentials{other: %{"username" => username}}),
    do: username

  defp username_from_credentials(_credentials), do: nil
end
