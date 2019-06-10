defmodule BlogAppWeb.LayoutView do
  use BlogAppWeb, :view

  def admin_navigation(conn, current_user) do
    [
      ["Posts", Routes.post_path(conn, :admin_index)],
      ["Comments", Routes.comment_path(conn, :index)],
      ["Categories", Routes.category_path(conn, :index)],
      ["Users", Routes.user_path(conn, :index)]
    ]
  end
end
