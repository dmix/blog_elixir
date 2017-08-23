defmodule BlogApp.Web.CommentHelper do
  alias BlogApp.Blog
  alias BlogApp.Blog.Comment
  alias BlogApp.Blog.Post
  alias BlogApp.Accounts.User
  alias BlogApp.Accounts.RoleChecker
  alias BlogApp.Repo

  def create(%{"postId" => post_id, "body" => body, "author" => author}, _socket) do
    Blog.create_comment(post_id, %{body: body, author: author})
  end

  def approve(%{"postId" => post_id, "commentId" => comment_id}, %{assigns: %{user: user_id}}) do
    authorize_and_perform(post_id, user_id, fn ->
      comment = Repo.get!(Comment, comment_id)
      changeset = Comment.changeset(comment, %{approved: true})
      Repo.update(changeset)
    end)
  end

  def approve(_params, %{}), do: {:error, "User is not authorized"}
  def approve(_params, nil), do: {:error, "User is not authorized"}

  def delete(%{"postId" => post_id, "commentId" => comment_id}, %{assigns: %{user: user_id}}) do
    authorize_and_perform(post_id, user_id, fn ->
      comment = Repo.get!(Comment, comment_id)
      Repo.delete(comment)
    end)
  end

  def delete(_params, %{}), do: {:error, "User is not authorized"}
  def delete(_params, nil), do: {:error, "User is not authorized"}

  defp authorize_and_perform(post_id, user_id, action) do
    post = get_post(post_id)
    user = get_user(user_id)
    if is_authorized_user?(user, post) do
      action.()
    else
      {:error, "User is not authorized"}
    end
  end

  defp get_user(user_id) do
    Repo.get!(User, user_id)
  end

  defp get_post(post_id) do
    Repo.get!(Post, post_id) |> Repo.preload([:user, :comments])
  end

  defp is_authorized_user?(user, post) do
    (user && (user.id == post.user_id || RoleChecker.is_admin?(user)))
  end
end
