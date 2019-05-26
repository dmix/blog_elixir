defmodule BlogAppWeb.ComponentsView do
  use BlogAppWeb, :view
  alias BlogApp.Blog.Post

  def navigation do
    [
      ["Home", "/", [{BlogAppWeb.PageController, :index}]],
      ["Blog", "/blog", [{BlogAppWeb.PostController, :any}]],
      ["Projects", "/projects", [{BlogAppWeb.PageController, :projects}]],
      ["About", "/about", [{BlogAppWeb.PageController, :about}]]
    ]
  end

  def relative_date(date) do
    Timex.format!(date, "{relative}", :relative)
  end

  def short_date(date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  def summary(text) do
    summary =
      text
      |> HtmlSanitizeEx.strip_tags()
      |> String.slice(0..300)

    "#{summary}..."
  end
end
