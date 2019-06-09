defmodule BlogApp.Accounts.Role do
  use BlogAppWeb, :data
  alias BlogApp.Accounts.Role
  alias BlogApp.Accounts.User

  schema "accounts_roles" do
    field(:admin, :boolean, default: false)
    field(:name, :string)

    timestamps()

    has_many(:users, User)
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name, :admin])
    |> validate_required([:name, :admin])
  end
end
