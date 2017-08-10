defmodule BlogApp.Repo.Migrations.CreateBlogApp.Blog.Comment do
  use Ecto.Migration

  def change do
    create table(:blog_comments) do
      add :author, :string
      add :body, :string
      add :approved, :boolean, default: false, null: false
      add :post_id, references(:blog_posts, on_delete: :nothing)

      timestamps()
    end

    create index(:blog_comments, [:post_id])
  end
end
