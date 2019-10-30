defmodule SauronWeb.EventView do
  use Phoenix.LiveView

  alias Sauron.EventAgent

  def render(assigns) do
    ~L"""
    <div>
      <form phx-change="filter">
        <input type="text" name="filter-text">
        <table>
          <tr>
            <td>Hide streams?</td>
            <td><input type="checkbox" name="hide-streams"></td>
          </tr>
          <tr>
            <td>Show dataset events?</td>
            <td><input type="checkbox" name="show-dataset" checked></td>
          </tr>
          <tr>
            <td>Show  organization events?</td>
            <td><input type="checkbox" name="show-org" checked></td>
          </tr>
        </table>
      </form>
      <%= for val <- filter_values(@values, @filter, @hide_streams, @show_dataset, @show_org) do %>
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

    {:ok,
     assign(socket,
       values: events,
       filter: "",
       hide_streams: false,
       show_dataset: true,
       show_org: true
     )}
  end

  def handle_event("filter", %{"filter-text" => filter_text} = changes, socket) do
    {:noreply,
     assign(socket,
       filter: filter_text,
       hide_streams: !!changes["hide-streams"],
       show_dataset: !!changes["show-dataset"],
       show_org: !!changes["show-org"]
     )}
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
      time: event.create_ts,
      is_stream: SmartCity.Dataset.is_stream?(event.data),
      struct_type: event.data.__struct__
    }
  end

  defp get_useful_info(%Brook.Event{data: %SmartCity.Organization{}} = event) do
    %{
      type: event.type,
      author: event.author,
      dataset_id: event.data.id,
      org_title: event.data.orgTitle,
      data_title: "n/a",
      time: event.create_ts,
      is_stream: false,
      struct_type: event.data.__struct__
    }
  end

  defp get_useful_info(event) do
    %{
      type: event.type,
      author: event.author,
      dataset_id: "???",
      org_title: "???",
      data_title: "???",
      time: event.create_ts,
      is_stream: false,
      struct_type: :unknown
    }
  end

  defp filter_values(values, filter, hide_streams, show_dataset, show_org) do
    values
    |> Enum.reject(fn val -> hide_streams && val.is_stream end)
    |> Enum.reject(fn val -> !show_dataset && val.struct_type == SmartCity.Dataset end)
    |> Enum.reject(fn val -> !show_org && val.struct_type == SmartCity.Organization end)
    |> Enum.filter(&String.contains?(inspect(&1), filter))
    |> Enum.take(5000)
  end
end
