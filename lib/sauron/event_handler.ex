defmodule Sauron.EventHandler do
  use Brook.Event.Handler

  alias Sauron.EventAgent

  require Logger

  def handle_event(%Brook.Event{} = event) do
    EventAgent.add_event(event)

    SauronWeb.Endpoint.broadcast!(
      "events",
      "new_event",
      event
    )

    :discard
  end

  # def handle_event(%Brook.Event{data: %SmartCity.Dataset{}} = event) do
  #   SauronWeb.Endpoint.broadcast!(
  #     "events",
  #     "dataset_event",
  #     event
  #   )

  #   :discard
  # end

  # def handle_event(%Brook.Event{data: %SmartCity.Organization{}} = event) do
  #   SauronWeb.Endpoint.broadcast!(
  #     "events",
  #     "organization_event",
  #     event
  #   )

  #   :discard
  # end

  # def handle_event(%Brook.Event{} = event) do
  #   SauronWeb.Endpoint.broadcast!(
  #     "events",
  #     "raw_event",
  #     event
  #   )

  #   :discard
  # end
end
