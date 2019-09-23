defmodule Sauron.EventHandler do
  use Brook.Event.Handler

  require Logger

  def handle_event(%Brook.Event{} = event) do
    SauronWeb.Endpoint.broadcast!(
      "events",
      "new_event",
      event
    )

    :discard
  end
end
