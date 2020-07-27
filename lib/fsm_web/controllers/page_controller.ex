defmodule FsmWeb.PageController do
  use FsmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
