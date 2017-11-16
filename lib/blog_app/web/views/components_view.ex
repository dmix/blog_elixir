defmodule BlogApp.Web.ComponentsView do
  use BlogApp.Web, :view
  alias BlogApp.Blog.Post

  def navigation do
    [
      ["Home",     "/",         [{BlogApp.Web.PageController, :index   }]],
      ["Blog",     "/blog",     [{BlogApp.Web.PostController, :any     }]],
      ["Projects", "/projects", [{BlogApp.Web.PageController, :projects}]],
      ["About",    "/about",    [{BlogApp.Web.PageController, :about   }]],
    ]
  end

  def relative_date(date) do
    Timex.format!(date, "{relative}", :relative)
  end

  def short_date(date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  def summary(text) do
    summary = text
              |> HtmlSanitizeEx.strip_tags
              |> String.slice(0..300)
    "#{summary}..."
  end
end
