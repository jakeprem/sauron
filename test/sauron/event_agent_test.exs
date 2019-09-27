defmodule Sauron.EventAgentTest do
  use ExUnit.Case, async: true

  alias Sauron.EventAgent

  @max_events 2500

  test "stores event" do
    assert EventAgent.get_events() == []

    EventAgent.add_event(:event)
    assert EventAgent.get_events() == [:event]

    EventAgent.clear_events()
  end

  test "drops events after" do
    assert EventAgent.get_events() == []

    EventAgent.add_event(:event)
    Enum.map(1..@max_events, &EventAgent.add_event/1)

    refute EventAgent.get_events() |> Enum.member?(:event)

    EventAgent.clear_events()
  end

  test "clears events" do
    assert EventAgent.get_events() == []

    Enum.map(1..@max_events, &EventAgent.add_event/1)
    EventAgent.clear_events()

    assert EventAgent.get_events() == []
  end
end
