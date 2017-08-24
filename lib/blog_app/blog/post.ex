defmodule BlogApp.Blog.Post do
  use BlogApp.Web, :data
  alias BlogApp.Blog.Post

  schema "blog_posts" do
    field :body, :string
    field :title, :string
    field :permalink, :string
    field :category_names, :string, virtual: true

    timestamps()

    belongs_to :user, BlogApp.Accounts.User
    has_many :comments, BlogApp.Blog.Comment
    many_to_many :categories,
                 BlogApp.Blog.Category,
                 join_through: "blog_post_categories"
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :permalink, :body])
    |> validate_required([:title, :permalink, :body])
    |> strip_unsafe_body(attrs)
  end


  @spec strip_unsafe_body(Ecto.Changeset.t, map) :: any
  defp strip_unsafe_body(context, %{"body" => nil}), do: context
  defp strip_unsafe_body(context, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    context
    |> put_change(:body, clean_body)
  end
  defp strip_unsafe_body(context, _), do: context

end
