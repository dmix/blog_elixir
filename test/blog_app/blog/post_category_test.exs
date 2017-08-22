defmodule BlogApp.Blog.PostCategoryCategoryTest do
  use BlogApp.DataCase

  alias BlogApp.Blog
  alias BlogApp.Blog.Post
  alias BlogApp.Blog.PostCategory
  alias BlogApp.Blog.Category

  describe "post_category categories" do

    # PostCategory Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:post_category, %{post: insert(:post), category: insert(:category)})
    def invalid_attrs, do: valid_attrs() |> Map.put(:post_id, nil)
  
    # PostCategory Factories
    # -----------------------------------------------------------------------------

    def post_category_fixture do
      post_category = insert(:post_category, %{post: insert(:post), category: insert(:category)})
      Repo.get!(PostCategory, post_category.id) 
      |> Repo.preload(:post) 
      |> Repo.preload(:category)
    end

    # PostCategory Tests
    # -----------------------------------------------------------------------------

    test "create_post_category/1 with valid data creates a post category" do
      attrs = valid_attrs() 
      post = Repo.get!(Post, attrs.post_id)
      category = Repo.get!(Category, attrs.category_id)
      assert {:ok, %PostCategory{} = post} = Blog.create_post_category(post, category)
      assert post.post_id == attrs.post_id
      assert post.category_id == attrs.category_id
    end

    test "create_post_category/1 fails if post/category combo already exists" do
      post_category = post_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.create_post_category(post_category.post, post_category.category)
    end

    test "get_post_category!/1 returns the post_category with given id" do
      post_category = post_category_fixture()
      assert Blog.get_post_category!(post_category.id) == post_category
    end

    test "delete_post_category/1 deletes the post category" do
      post_category = post_category_fixture()
      assert {:ok, %PostCategory{}} = Blog.delete_post_category(post_category)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post_category!(post_category.id) end
    end

  end
end
