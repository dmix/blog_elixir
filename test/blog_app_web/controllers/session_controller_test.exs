defmodule BlogAppWeb.SessionControllerTest do
  use BlogAppWeb.ConnCase
  alias BlogAppWeb.Router.Helpers, as: Routes

  alias BlogApp.Accounts

  @username "dmix"
  @password "test"
  @valid_attrs %{"user" => %{"username" => @username, "password" => @password}}
  @invalid_attrs %{"user" => %{"username" => @username, "password" => "wrong_password"}}

  describe "authenticated" do
    setup do
      login_admin()
    end

    test "login page fails to render when authenticated", %{conn: conn, user: user} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 302)

      current_user = Plug.Conn.get_session(conn, :current_user)
      assert current_user.username == user.username

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Already logged in!"
    end

    test "logout when authenticated", %{conn: conn, user: user} do
      current_user = Plug.Conn.get_session(conn, :current_user)
      assert current_user.username == user.username

      conn = delete(conn, Routes.session_path(conn, :delete, current_user.id))
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Signed out successfully!"

      current_user = Plug.Conn.get_session(conn, :current_user)
      assert current_user == nil
    end
  end

  describe "unauthenticated" do
    setup do
      user_attrs =
        params_for(:user, %{
          role: insert(:role),
          username: @username,
          password: @password,
          password_confirmation: @password
        })

      Accounts.create_user(user_attrs)
      {:ok, conn: Phoenix.ConnTest.build_conn()}
    end

    test "login page renders when unauthenticated", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
    end

    test "authenticate with valid params", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), @valid_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      current_user = Plug.Conn.get_session(conn, :current_user)
      assert current_user.username == @username

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Sign in successful!"
    end

    test "fail to authenticate with invalid password", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), @invalid_attrs)
      current_user = Plug.Conn.get_session(conn, :current_user)
      assert current_user == nil
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Invalid username/password combination!"
    end

    test "fail to logout without authentication", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete, 1))
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Signed out successfully!"
    end
  end
end
