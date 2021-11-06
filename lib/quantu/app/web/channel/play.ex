defmodule Quantu.App.Web.Channel.Play do
  use Quantu.App.Web, :channel

  alias Quantu.App.Web.Socket

  def join("play", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def terminate(_reason, socket) do
    broadcast_from!(socket, "peer_leave", %{peer: Socket.User.id(socket)})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast_from!(socket, "peer_join", %{peer: Socket.User.id(socket)})
    {:noreply, socket}
  end

  def handle_info(
        %{event: "phx_leave"},
        socket
      ) do
    broadcast_from!(socket, "peer_leave", %{peer: Socket.User.id(socket)})
    {:stop, {:shutdown, :left}, socket}
  end

  def handle_info({:DOWN, _, _, reason}, %{} = socket) do
    reason = if reason == :normal, do: {:shutdown, :closed}, else: reason
    broadcast_from!(socket, "peer_leave", %{peer: Socket.User.id(socket)})
    {:stop, reason, socket}
  end

  def handle_in("phx_leave", socket) do
    broadcast_from!(socket, "peer_leave", %{peer: Socket.User.id(socket)})
    {:noreply, socket}
  end

  def handle_in("announce", _payload, socket) do
    broadcast_from!(socket, "announce", %{peer: Socket.User.id(socket)})
    {:noreply, socket}
  end

  def handle_in("respond", %{"to" => to}, socket) do
    broadcast_from!(socket, "respond", %{from: Socket.User.id(socket), to: to})
    {:noreply, socket}
  end

  def handle_in("broadcast", %{"payload" => payload}, socket) do
    broadcast_from!(socket, "broadcast", %{from: Socket.User.id(socket), payload: payload})
    {:noreply, socket}
  end

  def handle_in(
        "send",
        %{"to" => to, "payload" => payload},
        socket
      ) do
    broadcast_from!(socket, "send", %{from: Socket.User.id(socket), to: to, payload: payload})
    {:noreply, socket}
  end
end
