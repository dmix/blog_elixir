defmodule BlogAppWeb.CategoryController do
  use BlogAppWeb, :controller

  alias BlogApp.Blog
  alias BlogApp.Blog.Category
  alias BlogApp.Accounts
 
  plug :authorize_admin when action in [:index, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    categories = Blog.list_categories
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Blog.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Blog.create_category(category_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    category = Blog.get_category!(id)
    changeset = Blog.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Blog.get_category!(id)
    case Blog.update_category(category, category_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Blog.get_category!(id)
    {:ok, _category} = Blog.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end

  defp authorize_admin(conn, _) do
    user = get_session(conn, :current_user)
    if user && Accounts.RoleChecker.is_admin?(user) do
      conn
    else
    conn
      |> put_flash(:error, "You are not authorized to admin categories")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
