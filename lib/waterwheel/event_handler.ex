defmodule Waterwheel.EventHandler do
  use Brook.Event.Handler

  require Logger

  def handle_event(%Brook.Event{} = event) do
    WaterwheelWeb.Endpoint.broadcast!(
      "events",
      "new_event",
      event
    )

    :discard
  end
end
