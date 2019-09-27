defmodule SauronWeb.EventChannel do
  use SauronWeb, :channel

  alias Sauron.EventAgent

  def join("events", _message, socket) do

    {:ok, socket}
  end

  def handle_in("new_event", event, socket) do
    EventAgent.add_event(event)
    push(socket, "cached_events", %{events: EventAgent.get_events()})

    {:noreply, socket}
  end
end
