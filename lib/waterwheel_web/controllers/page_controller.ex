defmodule WaterwheelWeb.PageController do
  use WaterwheelWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, WaterwheelWeb.GithubDeployView, session: %{})
  end
end
