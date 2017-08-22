defmodule BlogApp.Web.CommentView do
  use BlogApp.Web, :view
  alias BlogApp.Web.CommentView

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

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
