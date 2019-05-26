defmodule BlogAppWeb.CommentView do
  use BlogAppWeb, :view
  alias BlogAppWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      approved: comment.approved,
      author: comment.author,
      body: comment.body}
  end
end
