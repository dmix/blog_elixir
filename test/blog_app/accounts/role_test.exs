defmodule BlogApp.Accounts.RoleTest do
  use BlogApp.DataCase

  alias BlogApp.Accounts
  alias BlogApp.Accounts.Role

  describe "roles" do

    # Role Attributes 
    # -----------------------------------------------------------------------------

    def valid_attrs,   do: params_for(:role)
    def update_attrs,  do: valid_attrs() |> Map.put(:name, Faker.Name.title())
    def invalid_attrs, do: valid_attrs() |> Map.put(:name, "")
  
    # Role Factories
    # -----------------------------------------------------------------------------

    def role_fixture do
      role = insert(:role)
      Repo.get!(Role, role.id)
    end

    # Role Tests
    # -----------------------------------------------------------------------------
 
    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      attrs = valid_attrs() 
      assert {:ok, %Role{} = role} = Accounts.create_role(attrs)
      assert role.name == attrs.name
      assert role.admin == attrs.admin
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(invalid_attrs())
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      attrs = update_attrs() 
      assert {:ok, role} = Accounts.update_role(role, attrs)
      assert %Role{} = role
      assert role.name == attrs.name
      assert role.admin == attrs.admin
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      attrs = invalid_attrs() 
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end
