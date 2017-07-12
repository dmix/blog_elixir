defmodule Blog.PostView do
  use Blog.Web, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end
