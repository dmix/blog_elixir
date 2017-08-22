defmodule BlogApp.Web.CommentController do
  use BlogApp.Web, :controller

  alias BlogApp.Blog
  alias BlogApp.Blog.Comment
  alias BlogApp.Blog.Post

  plug :scrub_params, "comment" when action in [:create, :update]
  #plug :set_post_and_authorize_user when action in [:update, :delete]

  action_fallback BlogApp.Web.FallbackController

  def index(conn, _params) do
    comments = Blog.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def index(conn, %{"post_id" => post_id}) do
    comments = Blog.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    comment = Blog.create_comment(post_id, comment_params)
    with {:ok, %Comment{} = comment} <- comment do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_comment_path(conn, :show, post_id, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"post_id" => post_id, "id" => id}) do
    comment = Blog.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"post_id" => post_id, "id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Blog.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"post_id" => post_id, "id" => id}) do
    comment = Blog.get_comment!(id)
    with {:ok, %Comment{}} <- Blog.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end

  # defp set_post(conn) do
  #   post = Repo.get!(Post, conn.params["post_id"]) |> Repo.preload(:user)
  #   assign(conn, :post, post)
  # end
  #
  # defp set_post_and_authorize_user(conn, _opts) do
  #   conn = set_post(conn)
  #   if is_authorized_user?(conn) do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You are not authorized to modify that comment!")
  #     |> redirect(to: page_path(conn, :index))
  #     |> halt
  #   end
  # end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    post = conn.assigns[:post]
    user && (user.id == post.user_id || Accounts.RoleChecker.is_admin?(user))
  end
end
