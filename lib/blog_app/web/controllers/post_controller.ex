defmodule BlogApp.Web.PostController do
  use BlogApp.Web, :controller

  alias BlogApp.Blog
  alias BlogApp.Blog.Post
 
  plug :assign_user when not action in [:index]
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  plug :set_authorization_flag

  def index(conn, %{"user_id" => _user_id}) do
    conn = assign_user(conn, nil)
    if conn.assigns[:user] do
      posts = Repo.all(Ecto.assoc(conn.assigns[:user], :posts)) 
              |> Repo.preload(:user)
      # user = Ecto.assoc(conn.assigns[:user], :posts)
      # posts = Blog.list_posts(user)
      render(conn, "index.html", posts: posts)
    else
      conn
    end
  end

  def index(conn, _params) do
    user = Ecto.assoc(conn.assigns[:user], :posts)
    posts = Blog.list_posts(user)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> Ecto.build_assoc(:posts)
      |> Blog.change_post(%BlogApp.Blog.Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns[:user]
           |> Ecto.build_assoc(:posts)
    case Blog.create_post(user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: user_post_path(conn, :index, conn.assigns[:user]))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Ecto.assoc(conn.assigns[:user], :posts)
    post = Blog.get_post!(user, id) 
           |> Ecto.build_assoc(:comments)
    comment_changeset = Blog.comment_changeset(post)
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = Ecto.assoc(conn.assigns[:user], :posts)
    post = Blog.get_post!(user, id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    user = Ecto.assoc(conn.assigns[:user], :posts)
    post = Blog.get_post!(user, id)
    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: user_post_path(conn, :show, conn.assigns[:user], post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Ecto.assoc(conn.assigns[:user])
    post = Blog.get_post!(user, id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: user_post_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(Blog.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (Integer.to_string(user.id) == conn.params["user_id"] || Blog.RoleChecker.is_admin?(user)))
  end

  defp authorize_user(conn, _) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end
end
