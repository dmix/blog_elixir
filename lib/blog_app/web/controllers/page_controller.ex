defmodule BlogApp.Web.PageController do
  use BlogApp.Web, :controller

  plug :put_layout, "app.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
