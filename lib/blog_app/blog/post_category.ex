defmodule BlogApp.Blog.PostCategory do
  use BlogApp.Web, :data
  alias BlogApp.Blog.PostCategory

  schema "blog_post_categories" do
    @primary_key false
    belongs_to :posts, BlogApp.Blog.Post, foreign_key: :post_id
    belongs_to :categories, BlogApp.Blog.Category, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(%PostCategory{} = post_category, attrs) do
    post_category
    |> cast(attrs, [:post_id, :category_id])
    |> validate_required([:post_id, :category_id])
    |> unique_constraint(:post_id, 
                         name: :post_categories_id_index)
  end
end

# # Create the user. Note that the (empty) `organizations` field has to be preloaded.
# user_map = %{display_name: "User 1", login_name: "1@y.com", password: "password"}
# changeset = User.password_setting_changeset(%User{}, user_map)
# user = Repo.insert!(changeset) |> Repo.preload(:organizations)
#
# # Do the same for the organization:
# org = %Eecrit.Organization{short_name: "org1", full_name: "Organization 1"}
# org = Repo.insert!(org) |> Repo.preload(:users)
#
# # Update one of the two of them:
# changeset = Ecto.Changeset.change(user) |> Ecto.Changeset.put_assoc(:organizations, [org])
#
# # "When you save this change to the user, the join table will have its foreign keys populated in both directions."
# Repo.update!(changeset)
