defmodule SauronWeb.EventView do
  use Phoenix.LiveView

  alias Sauron.EventAgent

  def render(assigns) do
    ~L"""
    <div>
      <form phx-change="filter">
        <input type="text" phx-change="filter" name="filter-text">
      </form>
      <%= for val <- filter_values(@values, @filter) do %>
        <ul>
          <li>Event Type: <strong><%= val.type %></strong></li>
          <li>Author: <strong><%= val.author %></strong></li>
          <li>Dataset ID: <strong><%= val.dataset_id %></strong></li>
          <li>Organization: <strong><%= val.org_title %></strong></li>
          <li>Data Title: <strong><%= val.data_title %></strong></li>
          <li>Time: <strong><%= val.time %></strong></li>
        </ul>
        <hr>
      <% end %>
    </div>
    """
  end

  def mount(_session, socket) do
    SauronWeb.Endpoint.subscribe("events")

    events = EventAgent.get_events() |> Enum.map(&get_useful_info/1)

    {:ok, assign(socket, values: events, filter: "")}
  end

  def handle_event("filter", %{"filter-text" => filter_text}, socket) do
    {:noreply, assign(socket, filter: filter_text)}
  end

  def handle_info(%{payload: event}, socket) do
    vals = [get_useful_info(event) | socket.assigns.values]

    {:noreply, assign(socket, values: vals)}
  end

  defp get_useful_info(%Brook.Event{data: %SmartCity.Dataset{}} = event) do
    %{
      type: event.type,
      author: event.author,
      dataset_id: event.data.id,
      org_title: event.data.business.orgTitle,
      data_title: event.data.business.dataTitle,
      time: event.create_ts
    }
  end

  defp get_useful_info(%Brook.Event{data: %SmartCity.Organization{}} = event) do
    %{
      type: event.type,
      author: event.author,
      dataset_id: event.data.id,
      org_title: event.data.orgTitle,
      data_title: "n/a",
      time: event.create_ts
    }
  end

  defp get_useful_info(event) do
    %{
      type: event.type,
      author: event.author,
      dataset_id: "???",
      org_title: "???",
      data_title: "???",
      time: event.create_ts
    }
  end

  defp filter_values(values, filter) do
    Enum.filter(values, &String.contains?(inspect(&1), filter))
  end
end
