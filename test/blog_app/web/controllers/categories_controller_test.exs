defmodule BlogApp.Web.CategoryControllerTest do
  use BlogApp.Web.ConnCase

  alias BlogApp.Blog

  # Category Attributes 
  # -----------------------------------------------------------------------------

  def valid_attrs,   do: params_for(:category)
  def update_attrs,  do: valid_attrs() |> Map.put(:name, Faker.Name.title())
  def invalid_attrs, do: valid_attrs() |> Map.put(:name, "")

  # Category Factories
  # -----------------------------------------------------------------------------
 
  def fixture(:category) do
    {:ok, category} = Blog.create_category(valid_attrs())
    category 
  end

  # Category Controller Tests
  # -----------------------------------------------------------------------------

  describe "unauthenticated" do

    test "categories index requires authentication", %{conn: conn} do
      conn = get conn, category_path(conn, :index)
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "creating category requires authentication", %{conn: conn} do
      conn = post conn, category_path(conn, :create), category: %{}
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "updates chosen category and redirects when data is valid", %{conn: conn} do
      category = fixture(:category)
      conn = put conn, category_path(conn, :update, category), category: update_attrs()
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "deletes chosen category", %{conn: conn} do
      category = fixture(:category)
      conn = delete conn, category_path(conn, :delete, category)
      assert conn.halted == true
      assert html_response(conn, 302)
    end
  end

  describe "authenticated" do

    setup do
      login_admin()
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, category_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Categories"
    end

    test "renders form for new categories", %{conn: conn} do
      conn = get conn, category_path(conn, :new)
      assert html_response(conn, 200) =~ "New Category"
    end

    test "creates category and redirects to index when data is valid", %{conn: conn} do
      category = valid_attrs()
      conn = post conn, category_path(conn, :create), category: category
      assert redirected_to(conn) == category_path(conn, :index)

      conn = get conn, category_path(conn, :index)
      assert html_response(conn, 200) =~ category.name
    end

    test "does not create category and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, category_path(conn, :create), category: invalid_attrs()
      assert html_response(conn, 200) =~ "New Category"
    end

    test "renders form for editing chosen category", %{conn: conn} do
      category = fixture(:category)
      conn = get conn, category_path(conn, :edit, category)
      assert html_response(conn, 200) =~ "Edit Category"
    end

    test "updates chosen category and redirects when data is valid", %{conn: conn} do
      category = fixture(:category)
      updated = update_attrs()
      conn = put conn, category_path(conn, :update, category), category: updated
      assert redirected_to(conn) == category_path(conn, :index)

      conn = get conn, category_path(conn, :index)
      assert html_response(conn, 200) =~ updated.name
    end

    test "does not update chosen category and renders errors when data is invalid", %{conn: conn} do
      category = fixture(:category)
      conn = put conn, category_path(conn, :update, category), category: invalid_attrs()
      assert html_response(conn, 200) =~ "Edit Category"
    end

    test "deletes chosen category", %{conn: conn} do
      category = fixture(:category)
      conn = delete conn, category_path(conn, :delete, category)
      assert redirected_to(conn) == category_path(conn, :index)
    end
  end

end
