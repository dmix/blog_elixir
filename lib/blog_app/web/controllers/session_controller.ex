defmodule BlogApp.Web.SessionController do
  use BlogApp.Web, :controller
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  alias BlogApp.Accounts
  alias BlogApp.Accounts.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    user = get_session(conn, :current_user)
    if user do
      conn
      |> put_flash(:error, "Already logged in!")
      |> redirect(to: page_path(conn, :index))
    else
      render conn, "new.html", changeset: Accounts.changeset(%User{})
    end
  end

  @spec create(Plug.Conn.t, map) :: no_return
  def create(conn, %{"user" => %{"username" => username, "password" => password}})
                   when not is_nil(username) and not is_nil(password) do
    user = Accounts.create_session(username)
    sign_in user, password, conn
  end

  @spec create(Plug.Conn.t, none) :: no_return
  def create(conn, _) do
    failed_login conn
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: page_path(conn, :index))
  end

  @spec sign_in(atom, atom, Plug.Conn.t) :: no_return
  defp sign_in(user, _password, conn) when is_nil(user) do
    failed_login conn
  end

  @spec sign_in(Ecto.Repo.t, String.t, Plug.Conn.t) :: no_return
  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user,
                     %{
                       id: user.id,
                       username: user.username,
                       role_id: user.role_id,
                     })
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: page_path(conn, :index))
    else
      failed_login conn
    end
  end

  @spec failed_login(Plug.Conn.t) :: no_return
  defp failed_login(conn) do
    dummy_checkpw()
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:error, "Invalid username/password combination!")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end
