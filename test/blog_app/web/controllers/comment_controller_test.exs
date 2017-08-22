defmodule BlogApp.Web.CommentControllerTest do
  use BlogApp.Web.ConnCase

  alias BlogApp.Repo
  alias BlogApp.Blog
  alias BlogApp.Blog.Comment

  # Comment Attributes 
  # -----------------------------------------------------------------------------

  def valid_attrs,   do: params_for(:comment, post: insert(:post))
  def invalid_attrs, do: valid_attrs() |> Map.put(:author, "")

  # Comment Factories
  # -----------------------------------------------------------------------------
 
  def fixture(:comment) do
    post = insert(:post, user: insert(:user))
    attrs = params_for(:comment, post: post)
    {:ok, comment} = Blog.create_comment(post.id, attrs)
    %{post: post, comment: comment, attrs: attrs}
  end

  # Comment Controller Tests
  # -----------------------------------------------------------------------------

  describe "unauthenticated user" do

    test "lists all comments", %{conn: conn} do
      %{post: post, comment: comment} = fixture(:comment)
      conn = get conn, post_comment_path(conn, :index, post.id)
      assert hd(json_response(conn, 200)["data"])["id"] == comment.id
    end

    test "creates and renders comment when data is valid", %{conn: conn} do
      comment = valid_attrs()
      post = Blog.get_post!(comment.post_id)
      conn = post conn, post_comment_path(conn, :create, post), comment: comment 

      assert json_response(conn, 201)["data"]["id"]
      assert Repo.get_by(Comment, comment)
    end

    test "does not create comment and renders errors when data is invalid", %{conn: conn} do
      comment = invalid_attrs()
      post = Blog.get_post!(comment.post_id)
      conn = post conn, post_comment_path(conn, :create, post), comment: comment

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "updates and renders chosen comment when data is valid", %{conn: conn} do
      %{post: post, comment: comment, attrs: attrs} = fixture(:comment)
      valid = attrs |> Map.put(:author, Faker.Internet.user_name())
      conn = put conn, post_comment_path(conn, :update, post, comment), comment: valid 
      assert json_response(conn, 200)["data"]["id"]
      assert Repo.get_by(Comment, valid)
    end

    test "does not update chosen comment and renders errors when data is invalid", %{conn: conn} do
      %{post: post, comment: comment, attrs: attrs} = fixture(:comment)
      invalid = attrs |> Map.put(:author, "")
      conn = put conn, post_comment_path(conn, :update, post, comment), comment: invalid 
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "deletes chosen comment", %{conn: conn} do
      %{post: post, comment: comment} = fixture(:comment)
      conn = delete conn, post_comment_path(conn, :delete, post, comment)
      assert response(conn, 204)
      refute Repo.get(Comment, comment.id)
    end

  end

  describe "authenticated admin" do

    setup do
      login_admin()
    end

    test "lists all entries on admin index", %{conn: conn} do
      %{post: _post, comment: comment, attrs: _attrs} = fixture(:comment)
      conn = get conn, comment_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Comments"
      assert html_response(conn, 200) =~  comment.author
    end

    # test "approve comments makes them display", %{conn: conn} do
    #   comment = fixture(:comment)
    #   conn = put conn, post_comment_path(conn, :update, comment), comment: update_attrs()
    #   assert conn.halted == true
    #   assert html_response(conn, 302)
    # end
  end
end
