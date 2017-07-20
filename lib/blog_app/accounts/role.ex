defmodule BlogApp.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApp.Accounts.Role

  schema "accounts_roles" do
    field :admin, :boolean, default: false
    field :name, :string

    timestamps()

    has_many :users, BlogApp.Accounts.User
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name, :admin])
    |> validate_required([:name, :admin])
  end

  
end
