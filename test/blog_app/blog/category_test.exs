defmodule BlogApp.Blog.CategoryTest do
  use BlogApp.DataCase

  alias BlogApp.Blog
  alias BlogApp.Blog.Category

  describe "categories" do

    # Category Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:category)
    def update_attrs,  do: valid_attrs() |> Map.put(:name, Faker.Name.title())
    def invalid_attrs, do: valid_attrs() |> Map.put(:name, "")
  
    # Category Factories
    # -----------------------------------------------------------------------------

    def category_fixture do
      category = insert(:category)
      Repo.get!(Category, category.id)
    end

    # Category Tests
    # -----------------------------------------------------------------------------
 
    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Blog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Blog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      attrs = valid_attrs() 
      assert {:ok, %Category{} = category} = Blog.create_category(attrs)
      assert category.name == attrs.name
      assert category.permalink == attrs.permalink
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_category(invalid_attrs())
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      attrs = update_attrs() 
      assert {:ok, category} = Blog.update_category(category, attrs)
      assert %Category{} = category
      assert category.name == attrs.name
      assert category.permalink == attrs.permalink
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Blog.update_category(category, attrs)
      assert category == Blog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Blog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Blog.change_category(category)
    end
  end
end
