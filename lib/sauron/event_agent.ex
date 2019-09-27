defmodule Sauron.EventAgent do
  use Agent

  @max_events 100

  def start_link(_initial_value) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get_events do
    Agent.get(__MODULE__, & &1)
  end

  def add_event(event) do
    Agent.update(__MODULE__, fn events ->
      Enum.take([event | events], @max_events)
    end)
  end
end
