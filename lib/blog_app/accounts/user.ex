defmodule BlogApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApp.Accounts.User
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "accounts_users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string

    timestamps()

    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :posts, BlogApp.Blog.Post
    belongs_to :role, BlogApp.Accounts.Role
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation, :role_id])
    |> validate_required([:username, :email, :password, :password_confirmation, :role_id])
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end
end
