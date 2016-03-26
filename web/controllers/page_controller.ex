defmodule PhoenixPoker.PageController do
  use PhoenixPoker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
