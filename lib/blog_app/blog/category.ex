defmodule BlogApp.Blog.Category do
  use BlogApp.Web, :data
  alias BlogApp.Blog.Category

  schema "blog_categories" do
    field :name, :string
    field :permalink, :string
    field :description, :string
    field :icon, :string

    many_to_many :posts, BlogApp.Blog.Post, join_through: "blog_post_categories"

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name, :permalink, :description, :icon])
    |> validate_required([:name, :permalink, :description, :icon])
  end
end
