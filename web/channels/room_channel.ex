defmodule PhoenixPoker.RoomChannel do
  use PhoenixPoker.Web, :channel

  intercept ["player_reply"]

  def join("rooms:" <> _room_id, %{"name" => name}, socket) do
    player = Map.put(socket.assigns[:player], :name, name)
    socket = assign(socket, :player, player)
    send self, :after_join

    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast! socket, "player_joined", socket.assigns[:player]
    broadcast! socket, "player_reply", socket.assigns[:player]
    {:noreply, socket}
  end

  def terminate(message, socket) do
    broadcast! socket, "player_left", socket.assigns[:player]
    {:ok, socket}
  end

  def handle_in("player_left", player, socket) do
    broadcast! socket, "player_left", player
    {:noreply, socket}
  end

  def handle_out("player_reply", player, socket) do
    # let other players reply with their own info when a new player joins
    if player[:id] != socket.assigns[:player][:id] do
      broadcast! socket, "player_joined", socket.assigns[:player]
    end

    {:noreply, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
