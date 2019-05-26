# defmodule BlogAppWeb.CommentController do
#   use BlogAppWeb, :controller
#
#   alias BlogApp.Blog
#   alias BlogApp.Comment
#   alias BlogApp.Post
#
#   plug :scrub_params, "comment" when action in [:create, :update]
#   plug :set_post_and_authorize_user when action in [:update, :delete]
#
#   def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
#     post = Account.get_user!(post_id)
#            |> Repo.preload([:user, :comments])
#     case blog.create_comment(comment_params) do
#       {:ok, comment} ->
#         conn
#         |> put_flash(:info, "Comment created successfully.")
#         |> redirect(to: Routes.post_path(conn, :show, post.permalink))
#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, Blog.PostView, "show.html", post: post, user: post.user, comment_changeset: changeset)
#     end
#   end
#
#   def update(conn, %{"id" => id, "post_id" => post_id, "comment" => comment_params}) do
#     post = Account.get_user!(post_id)
#            |> Repo.preload([:user, :comments])
#     comment = Blog.get_comment!(id)
#
#     case Blog.update_comment(comment, comment_params) do
#       {:ok, comment} ->
#         conn
#         |> put_flash(:info, "Comment updated successfully.")
#         |> redirect(to: Routes.post_path(conn, :show, post.permalink))
#       {:error, %Ecto.Changeset{} = changeset} ->
#         conn
#         |> put_flash(:info, "Failed to update comment!")
#         |> redirect(to: Routes.post_path(conn, :show, post.permalink))
#     end
#   end
#
#   def delete(conn, %{"id" => id, "post_id" => post_id}) do
#     post = Repo.get!(Post, post_id) |> Repo.preload(:user)
#     comment = Blog.get_comment!(id)
#     {:ok, _comment} = Blog.delete_comment(comment)
#
#     conn
#     |> put_flash(:info, "Comment deleted successfully.")
#     |> redirect(to: Routes.post_path(conn, :show, post.permalink))
#   end
#
#   defp set_post(conn) do
#     post = Repo.get!(Post, conn.params["post_id"]) |> Repo.preload(:user)
#     assign(conn, :post, post)
#   end
#
#   defp set_post_and_authorize_user(conn, _opts) do
#     conn = set_post(conn)
#     if is_authorized_user?(conn) do
#       conn
#     else
#       conn
#       |> put_flash(:error, "You are not authorized to modify that comment!")
#       |> redirect(to: Routes.page_path(conn, :index))
#       |> halt
#     end
#   end
#
#   defp is_authorized_user?(conn) do
#     user = get_session(conn, :current_user)
#     post = conn.assigns[:post]
#     user && (user.id == post.user_id || Accounts.RoleChecker.is_admin?(user))
#   end
# end
