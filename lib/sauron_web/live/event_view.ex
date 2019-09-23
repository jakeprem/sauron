defmodule SauronWeb.EventView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <%= for val <- @values do %>
        <ul>
          <li>Event Type: <strong><%= val.type %></strong></li>
          <li>Author: <strong><%= val.author %></strong></li>
          <li>Dataset ID: <strong><%= val.dataset_id %></strong></li>
          <li>Time: <strong><%= val.time %></strong></li>
        </ul>
        <hr>
      <% end %>
    </div>
    """
  end

  def mount(_session, socket) do
    SauronWeb.Endpoint.subscribe("events")

    {:ok, assign(socket, values: [])}
  end

  def handle_info(%{payload: event}, socket) do
    vals = [get_useful_info(event) | socket.assigns.values]

    {:noreply, assign(socket, values: vals)}
  end

  defp get_useful_info(event) do
    IO.inspect(event)

    %{
      type: event.type,
      author: event.author,
      dataset_id: event.data.id,
      time: event.create_ts
    }
  end
end
