defmodule BlogApp.Web.PostView do
  use BlogApp.Web, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end
