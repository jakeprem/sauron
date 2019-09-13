defmodule WaterwheelWeb.PageController do
  use WaterwheelWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
