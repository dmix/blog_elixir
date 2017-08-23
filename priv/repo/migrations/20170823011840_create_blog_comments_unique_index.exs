defmodule BlogApp.Repo.Migrations.CreateBlogCommentsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:blog_comments, [:author, :body], name: :comments_author_body_index)
  end
end
