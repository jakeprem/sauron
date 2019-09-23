defmodule SauronWeb.PageController do
  use SauronWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, SauronWeb.EventView, session: %{})
  end
end
