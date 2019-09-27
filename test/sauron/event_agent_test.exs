defmodule Sauron.EventAgentTest do
  use ExUnit.Case, async: true

  alias Sauron.EventAgent

  @max_events 100

  test "stores event" do
    {:ok, pid} = EventAgent.start_link(nil)

    assert EventAgent.get_events() == []
    EventAgent.add_event(:event)
    assert EventAgent.get_events() == [:event]

    Agent.stop(pid)
  end

  test "drops events after" do
    {:ok, pid} = EventAgent.start_link(nil)

    assert EventAgent.get_events() == []

    EventAgent.add_event(:event)
    Enum.map(1..@max_events, &EventAgent.add_event/1)

    refute EventAgent.get_events() |> Enum.member?(:event)

    Agent.stop(pid)
  end
end
