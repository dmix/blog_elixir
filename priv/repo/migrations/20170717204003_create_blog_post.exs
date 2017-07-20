defmodule BlogApp.Web.Repo.Migrations.CreateBlogApp.Blog.Post do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string
      add :body, :string
      add :user_id, references(:accounts_users, on_delete: :nothing)

      timestamps()
    end

    create index(:blog_posts, [:user_id])
  end
end
