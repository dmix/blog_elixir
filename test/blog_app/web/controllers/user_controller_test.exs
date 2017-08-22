defmodule BlogApp.Web.UserControllerTest do
  use BlogApp.Web.ConnCase

  alias BlogApp.Accounts

  # User Attributes 
  # -----------------------------------------------------------------------------

  def valid_attrs,   do: params_for(:user, role: insert(:role))
  def update_attrs,  do: valid_attrs() |> Map.put(:email, Faker.Internet.email())
  def invalid_attrs, do: valid_attrs() |> Map.put(:email, "")

  # User Factories
  # -----------------------------------------------------------------------------
 
  def fixture(:user) do
    {:ok, user} = Accounts.create_user(valid_attrs())
    user 
  end

  # User Controller Tests
  # -----------------------------------------------------------------------------

  describe "unauthenticated" do

    test "users index requires authentication", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "creating user requires authentication", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: %{}
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "updates chosen user and redirects when data is valid", %{conn: conn} do
      user = fixture(:user)
      conn = put conn, user_path(conn, :update, user), user: update_attrs()
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "deletes chosen user", %{conn: conn} do
      user = fixture(:user)
      conn = delete conn, user_path(conn, :delete, user)
      assert conn.halted == true
      assert html_response(conn, 302)
    end
  end

  describe "authenticated" do

    setup do
      login_admin()
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "renders form for new users", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end

    test "creates user and redirects to index when data is valid", %{conn: conn} do
      user = valid_attrs()
      conn = post conn, user_path(conn, :create), user: user
      assert redirected_to(conn) == user_path(conn, :index)

      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ user.username
    end

    test "does not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: invalid_attrs()
      assert html_response(conn, 200) =~ "New User"
    end

    test "renders form for editing chosen user", %{conn: conn} do
      user = fixture(:user)
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "updates chosen user and redirects when data is valid", %{conn: conn} do
      user = fixture(:user)
      updated = update_attrs()
      conn = put conn, user_path(conn, :update, user), user: updated
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ updated.username
    end

    test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
      user = fixture(:user)
      conn = put conn, user_path(conn, :update, user), user: invalid_attrs()
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "deletes chosen user", %{conn: conn} do
      user = fixture(:user)
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
    end
  end

end
