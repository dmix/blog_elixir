defmodule BlogApp.Accounts.UserTest do
  use BlogApp.DataCase

  alias BlogApp.Accounts
  alias BlogApp.Accounts.User

  describe "users" do

    # User Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:user, role: insert(:role))
    def update_attrs,  do: valid_attrs() |> Map.put(:email, Faker.Internet.email())
    def invalid_attrs, do: valid_attrs() |> Map.put(:email, "")
  
    # User Factories
    # -----------------------------------------------------------------------------

    def fixture(:user) do
      user = insert(:user, role: insert(:role))
      Repo.get!(User, user.id)
    end

    # User Tests
    # -----------------------------------------------------------------------------
 
    test "list_users/0 returns all users" do
      user = fixture(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = fixture(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_attrs() 
      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.email == attrs.email
      assert user.username == attrs.username
      assert user.password_digest != nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs())
    end

    test "update_user/2 with valid data updates the user" do
      user = fixture(:user)
      attrs = update_attrs() 
      assert {:ok, user} = Accounts.update_user(user, attrs)
      assert %User{} = user
      assert user.email == attrs.email
      assert user.username == attrs.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = fixture(:user)
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = fixture(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = fixture(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
