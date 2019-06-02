defmodule BlogAppWeb.UserController do
  use BlogAppWeb, :controller

  alias BlogApp.Accounts

  plug :authorize_admin when action in [:index, :new, :create]
  plug :authorize_user  when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    roles = Accounts.list_roles()
    changeset = Accounts.change_user(%BlogApp.Accounts.User{})
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    roles = Accounts.list_roles()
    case Accounts.create_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, roles: roles)
    end
  end

  def edit(conn, %{"id" => id}) do
    roles = Accounts.list_roles()
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    roles = Accounts.list_roles()
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  defp authorize_user(conn, _) do
    user = get_session(conn, :current_user)
    if user && (Integer.to_string(user.id) == conn.params["id"] || Accounts.RoleChecker.is_admin?(user)) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that user!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_admin(conn, _) do
    user = get_session(conn, :current_user)
    if user && Accounts.RoleChecker.is_admin?(user) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to create new users!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
