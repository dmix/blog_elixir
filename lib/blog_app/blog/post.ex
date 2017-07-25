defmodule BlogApp.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApp.Blog.Post

  schema "blog_posts" do
    field :body, :string
    field :title, :string

    timestamps()

    belongs_to :user, BlogApp.Accounts.User
    has_many :comments, BlogApp.Blog.Comment
    many_to_many :categories, BlogApp.Blog.Category, join_through: "blog_post_categories"
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> strip_unsafe_body(attrs)
  end

  defp strip_unsafe_body(model, %{"body" => nil}) do
    model
  end

  defp strip_unsafe_body(model, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model |> put_change(:body, clean_body)
  end

  defp strip_unsafe_body(model, _) do
    model
  end
end
