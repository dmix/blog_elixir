defmodule BlogApp.Blog.Comment do
  use BlogApp.Web, :data
  alias BlogApp.Blog.Comment

  schema "blog_comments" do
    field :approved, :boolean, default: false
    field :author, :string
    field :body, :string

    belongs_to :post, BlogApp.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:author, :body, :approved])
    |> validate_required([:author, :body, :approved])
    |> unique_constraint(:author_body, name: :comments_author_body_index)
  end
end
