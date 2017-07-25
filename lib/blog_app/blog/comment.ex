defmodule BlogApp.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
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
  end
end
