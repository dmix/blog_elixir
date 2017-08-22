defmodule BlogApp.Blog.PostTest do
  use BlogApp.DataCase

  alias BlogApp.Accounts
  alias BlogApp.Blog
  alias BlogApp.Blog.Post

  describe "posts" do

    # Post Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:post, user: insert(:user))
    def update_attrs,  do: valid_attrs() |> Map.put(:body, Faker.Lorem.sentence())
    def invalid_attrs, do: valid_attrs() |> Map.put(:body, "")
  
    # Post Factories
    # -----------------------------------------------------------------------------

    def fixture(:post) do
      post = insert(:post, user: insert(:user))
      Repo.get!(Post, post.id) 
      |> Repo.preload(:user) 
      |> Repo.preload(:categories)
    end

    # Post Tests
    # -----------------------------------------------------------------------------
 
    test "list_posts/0 returns all posts" do
      post = fixture(:post)
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = fixture(:post)
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      attrs = valid_attrs() 
      user = Accounts.get_user!(attrs.user_id)
      assert {:ok, %Post{} = post} = Blog.create_post(user, attrs)
      assert post.body == attrs.body
      assert post.permalink == attrs.permalink
    end

    test "create_post/1 with invalid data returns error changeset" do
      attrs = invalid_attrs()
      user = Accounts.get_user!(attrs.user_id)
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(user, attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = fixture(:post)
      attrs = update_attrs() 
      assert {:ok, post} = Blog.update_post(post, attrs)
      assert %Post{} = post
      assert post.body == attrs.body
      assert post.permalink == attrs.permalink
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = fixture(:post)
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = fixture(:post)
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = valid_attrs()
      user = Accounts.get_user!(post.user_id)
      assert %Ecto.Changeset{} = Blog.change_post(user, post)
    end
  end
end
