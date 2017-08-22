defmodule BlogApp.Blog.CommentTest do
  use BlogApp.DataCase

  alias BlogApp.Blog
  alias BlogApp.Blog.Comment

  describe "comments" do

    # Comment Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:comment, post: insert(:post))
    def update_attrs,  do: valid_attrs() |> Map.put(:body, Faker.Lorem.sentence())
    def invalid_attrs, do: valid_attrs() |> Map.put(:body, "")
  
    # Comment Factories
    # -----------------------------------------------------------------------------

    def comment_fixture do
      comment = insert(:comment, post: insert(:post))
      Repo.get!(Comment, comment.id)
    end

    # Comment Tests
    # -----------------------------------------------------------------------------
 
    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Blog.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Blog.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      attrs = valid_attrs() 
      assert {:ok, %Comment{} = comment} = Blog.create_comment(attrs.post_id, attrs)
      assert comment.body == attrs.body
      assert comment.author == attrs.author
    end

    test "create_comment/1 with invalid data returns error changeset" do
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(attrs.post_id, attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      attrs = update_attrs() 
      assert {:ok, comment} = Blog.update_comment(comment, attrs)
      assert %Comment{} = comment
      assert comment.body == attrs.body
      assert comment.author == attrs.author
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Blog.update_comment(comment, attrs)
      assert comment == Blog.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Blog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Blog.change_comment(comment)
    end
  end
end
