defmodule YoloExampleWeb.PageController do
  use YoloExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
