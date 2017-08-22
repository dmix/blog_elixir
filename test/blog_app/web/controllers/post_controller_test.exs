defmodule BlogApp.Web.PostControllerTest do
  use BlogApp.Web.ConnCase

  alias BlogApp.Repo
  alias BlogApp.Blog
  alias BlogApp.Blog.Category
  alias BlogApp.Blog.Post
  alias BlogApp.Accounts
  alias BlogApp.Accounts.User

  # Post Attributes 
  # -----------------------------------------------------------------------------

  def valid_attrs,   do: params_for(:post, user: insert(:user))
  def update_attrs,  do: valid_attrs() |> Map.put(:body, Faker.Lorem.sentence())
  def invalid_attrs, do: valid_attrs() |> Map.put(:body, "")
  @category %{name: "Startups", 
              permalink: "startups", 
              description: "This is an example description", 
              icon: "book"}

  # Post Factories
  # -----------------------------------------------------------------------------
 
  def fixture(:post) do
    attrs = valid_attrs()
    user = Accounts.get_user!(attrs.user_id)
    {:ok, post} = Blog.create_post(user, attrs)
    post
  end

  def fixture(:user) do
    hd(Repo.all(User))
  end

  def fixture(:category) do
    hd(Repo.all(Category))
  end

  # Post Controller Tests
  # -----------------------------------------------------------------------------

  describe "unauthenticated" do

    test "creating post requires authentication", %{conn: conn} do
      post = fixture(:post)
      user = fixture(:user)
      conn = post conn, user_post_path(conn, :create, user), post: @create_attrs
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "updates chosen post and redirects when data is valid", %{conn: conn} do
      post = fixture(:post)
      user = fixture(:user)
      conn = put conn, user_post_path(conn, :update, user, post), post: update_attrs()
      assert conn.halted == true
      assert html_response(conn, 302)
    end

    test "deletes chosen post", %{conn: conn} do
      post = fixture(:post)
      user = fixture(:user)
      conn = delete conn, user_post_path(conn, :delete, user, post)
      assert conn.halted == true
      assert html_response(conn, 302)
    end
  end

  describe "authenticated" do

    setup do
      Blog.create_category(@category)
      login_admin 
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert html_response(conn, 200) =~ "Blog"
    end

    test "renders form for new posts", %{conn: conn, user: user} do
      conn = get conn, user_post_path(conn, :new, user)
      assert html_response(conn, 200) =~ "New Post"
    end

    test "creates post and redirects to index when data is valid", %{conn: conn, user: user} do
      post = params_for(:post, user: user)
      categories = %{@category.name => ""}
      conn = post conn, user_post_path(conn, :create, user), post: post, categories: categories
      assert redirected_to(conn) == post_path(conn, :index)

      conn = get conn, post_path(conn, :index)
      assert html_response(conn, 200) =~ post.title
    end

    test "does not create post and renders errors when data is invalid", %{conn: conn, user: user} do
      categories = %{@category.name => ""}
      conn = post conn, user_post_path(conn, :create, user), post: invalid_attrs(), categories: categories
      assert html_response(conn, 200) =~ "New Post"
    end

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = insert(:post, user: user)
      conn = get conn, user_post_path(conn, :edit, user, post)
      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "updates chosen post and redirects when data is valid", %{conn: conn, user: user} do
      post = insert(:post, user: user)
      updated = update_attrs()
      categories = %{@category.name => ""}
      conn = put conn, user_post_path(conn, :update, user, post), post: updated, categories: categories
      assert redirected_to(conn) == post_path(conn, :show, updated.permalink)

      conn = get conn, post_path(conn, :index)
      assert html_response(conn, 200) =~ updated.title
    end

    test "does not update chosen post and renders errors when data is invalid", %{conn: conn, user: user} do
      attrs = params_for(:post, user: user)
      invalid = attrs |> Map.put(:body, "")
      {:ok, post} = Blog.create_post(user, attrs)
      categories = %{@category.name => ""}
      conn = put conn, user_post_path(conn, :update, post.user_id, post), post: invalid, categories: categories
      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "deletes chosen post", %{conn: conn, user: user} do
      post = insert(:post, user: user)
      conn = delete conn, user_post_path(conn, :delete, user, post)
      assert redirected_to(conn) == post_path(conn, :index)
    end
  end

end
