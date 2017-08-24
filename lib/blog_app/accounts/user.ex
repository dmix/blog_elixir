defmodule BlogApp.Accounts.User do
  use BlogApp.Web, :data
  import Comeonin.Argon2, only: [hashpwsalt: 1]
  alias BlogApp.Accounts.User

  schema "accounts_users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string
    field :primary, :boolean
    field :name, :string
    field :bio, :string
    field :avatar_url, :string
    field :twitter_url, :string
    field :github_url, :string
    field :linkedin_url, :string
    field :dribbble_url, :string

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
    |> cast(attrs,
       [
         :username,
         :email,
         :password,
         :password_confirmation,
         :role_id,
         :name,
         :bio,
         :avatar_url,
         :twitter_url,
         :linkedin_url,
         :github_url,
         :dribbble_url,
       ])
    |> validate_required([
         :username,
         :email,
         :password,
         :password_confirmation,
         :role_id,
         :name,
         :bio,
       ])
    |> hash_password
  end


  @spec hash_password(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end
end
