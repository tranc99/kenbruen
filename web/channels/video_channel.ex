defmodule Kenbruen.VideoChannel do
  use Kenbruen.Web, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
    # {:ok, assign(socket, :video_id, String.to_integer(video_id) )}
  end

  def handle_in("new_annotation", params, socket) do
    broadcast! socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    }

    {:reply, :ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push socket, "ping", %{count: count}

    {:noreply, assign(socket, :count, count + 1)}
  end
end
