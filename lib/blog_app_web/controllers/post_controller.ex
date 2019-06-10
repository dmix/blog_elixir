defmodule BlogAppWeb.PostController do
  use BlogAppWeb, :controller

  alias BlogApp.Blog
  alias BlogApp.Accounts

  plug(:assign_user when action not in [:index, :show, :admin_index])
  plug(:authorize_user when action in [:admin_index, :new, :create, :update, :edit, :delete])
  plug(:set_authorization_flag)
  plug(:put_layout, "admin.html" when action in [:admin_index, :new, :create, :edit, :delete])

  def index(conn, %{"category" => category_name}) do
    category = Blog.get_category_by_name!(category_name)

    if category do
      posts = Blog.list_category_posts(category.id)

      render(conn, "index.html",
        posts: posts,
        categories: Blog.list_category_names(),
        sidebar: true,
        category: category_name
      )
    else
      conn
    end
  end

  def index(conn, %{"user_id" => _user_id}) do
    conn = assign_user(conn, nil)

    if conn.assigns[:user] do
      user = Ecto.assoc(conn.assigns[:user], :posts)
      posts = Blog.list_posts(user)

      render(conn, "index.html",
        posts: posts,
        categories: Blog.list_category_names(),
        sidebar: true,
        category: nil
      )
    else
      conn
    end
  end

  def index(conn, _params) do
    render(conn, "index.html",
      posts: Blog.list_posts(),
      categories: Blog.list_category_names(),
      sidebar: true,
      category: nil
    )
  end

  def admin_index(conn, _params) do
    render(conn, "admin.html", posts: Blog.list_posts())
  end

  def new(conn, _params) do
    changeset = Blog.change_post(conn.assigns[:user])

    render(conn, "new.html",
      changeset: changeset,
      categories: Blog.list_category_names()
    )
  end

  def create(conn, %{"post" => post_params, "categories" => category_params}) do
    case Blog.create_post(conn.assigns[:user], post_params) do
      {:ok, post} ->
        Blog.append_categories(post, Map.values(category_params))

        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          categories: Blog.list_category_names()
        )
    end
  end

  def show(conn, %{"permalink" => permalink}) do
    post = Blog.get_post_by!(:permalink, permalink)
    comment_changeset = Blog.comment_changeset(post)
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns[:user]
    post = Blog.get_post!(user, id)
    comment_changeset = Blog.comment_changeset(post)
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns[:user]
    post = Blog.get_post!(user, id)
    changeset = Blog.change_post(user, %{})

    render(conn, "edit.html",
      post: post,
      changeset: changeset,
      categories: Blog.list_category_names()
    )
  end

  def update(conn, %{"id" => id, "post" => post_params, "categories" => category_params}) do
    user = conn.assigns[:user]
    post = Blog.get_post!(user, id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        Blog.append_categories(post, Map.values(category_params))

        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post.permalink))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          post: post,
          changeset: changeset,
          categories: Blog.list_category_names()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:user]
    post = Blog.get_post!(user, id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Accounts.get_user!(user_id) do
          nil -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end

      _ ->
        invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)

    user &&
      (Integer.to_string(user.id) == conn.params["user_id"] ||
         Accounts.RoleChecker.is_admin?(user))
  end

  defp authorize_user(conn, _) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end
end
