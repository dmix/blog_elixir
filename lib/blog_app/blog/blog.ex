defmodule BlogApp.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  use BlogApp.Web, :context

  alias BlogApp.Repo
  alias BlogApp.Blog.Comment
  alias BlogApp.Blog.Category
  alias BlogApp.Blog.Post
  alias BlogApp.Blog.PostCategory
  alias BlogApp.Accounts.User

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(from p in Post,
             order_by: [desc: :inserted_at],
             preload: [:user, :categories, :comments])
  end

  def list_category_posts(category_id) do
    post_ids = Repo.all(from p in PostCategory,
                        where: [category_id: ^category_id],
                        select: p.post_id)
    Repo.all(from p in Post,
             where: p.id in ^post_ids,
             order_by: [desc: :inserted_at],
             preload: [:user, :categories, :comments])
  end

  def list_posts(user_posts) do
    Repo.all(user_posts)
    |> Repo.preload(:user, :categories)
  end

  def last_post do
    Repo.one(from x in Post, order_by: [desc: x.id], limit: 1)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
    |> Repo.preload(:categories)
    |> Repo.preload(:comments)
  end

  @doc """
  Gets a single post authored by a particular user.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  Usage:

      user = Accounts.User{} // conn.assigns[:user]
      post = Blog.Post{}#id

  """
  def get_post!(%User{} = user, id) do
    Repo.one(from(p in Post,
                  where: [user_id: ^user.id, id: ^id],
                  preload: [:user, :categories, :comments]))
  end

  @doc """
  Get a single post by permalink

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post_by!(:permalink, "permalink")
      %Post{}

      iex> get_post_by!(:permalink, "")
      ** (Ecto.NoResultsError)

  """
  def get_post_by!(:permalink, permalink) do
    Repo.one(from(p in Post,
                  where: [permalink: ^permalink],
                  preload: [:user, :categories, :comments]))
  end

  def comment_changeset(post, attrs \\ %{}) do
    post
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(attrs)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%User{}, %{field: value})
      {:ok, %Post{}}

      iex> create_post(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(user, post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(user, post \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(post)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Returns the list of comments for a post.

  ## Examples

      iex> list_comments(%Post{})
      [%Comment{}, ...]

  """
  def list_comments(%Post{} = post) do
    Repo.all(from(p in Comment,
                  where: [post_id: ^post.id]))
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  def approve_comment(id) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, %{approved: true})
    Repo.update(changeset)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(post_id, attrs \\ %{}) do
    Repo.get!(Post, post_id)
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end


  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end


  def list_category_names do
    Repo.all(from c in Category,
             select: c.name)
  end

  def list_category_counts do
    categories = Repo.all(Category)
                 |> Repo.preload(:post)
    categories
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_category_by_name!(name) do
    Repo.one(from(p in Category, where: [name: ^name]))
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  @doc """
  Append Categories to a Post.

  ## Examples

      iex> append_categories(post, ["Startups", "Toronto"])
      [{:ok, %PostCategory{}}]

  """
  def append_categories(%Post{} = post, categories \\ []) do
    for name <- categories, name != "" do
      category = get_category_by_name!(name)
      attrs = %{:category_id => category.id, :post_id => post.id}
      changeset = PostCategory.changeset(%PostCategory{}, attrs)
      Repo.insert(changeset, on_conflict: :nothing)
    end
  end

  @doc """
  Create post category.

  ## Examples

      iex> create_post_category(post, category)
      [{:ok, %PostCategory{}}]

  """
  def create_post_category(%Post{} = post, %Category{} = category) do
    attrs = %{post_id: post.id, category_id: category.id}
    %PostCategory{}
    |> PostCategory.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Gets a single post_category.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post_category!(123)
      %Post{}

      iex> get_post_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_category!(id) do
    Repo.get!(PostCategory, id)
    |> Repo.preload(:post)
    |> Repo.preload(:category)
  end

  @doc """
  Delete post category.

  ## Examples

      iex> delete_post_category(post_category)
      {:ok, %PostCategory{}}

      iex> delete_post_category(post_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_category(%PostCategory{} = post_category) do
    Repo.delete(post_category)
  end

end
