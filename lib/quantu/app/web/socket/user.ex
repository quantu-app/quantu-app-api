defmodule Quantu.App.Web.Socket.User do
  use Phoenix.Socket
  require Logger

  @impl true
  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, Quantu.App.Web.Guardian, token) do
      {:ok, authed_socket} ->
        {:ok, authed_socket}

      {:error, _reason} ->
        :error
    end
  end

  @impl true
  def connect(_params, _socket) do
    :error
  end

  @impl true
  def id(socket), do: "user:#{Guardian.Phoenix.Socket.current_resource(socket).id}"
end
