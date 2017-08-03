defmodule BlogApp.Web.Repo.Migrations.AddBlogCategories do
  use Ecto.Migration

  def change do
    create table(:blog_categories) do
      add :name,        :string
      add :description, :string
      add :icon,        :string

      timestamps
    end

    create table(:blog_posts_categories) do
      add :blog_post_id, references(:blog_posts)
      add :blog_category_id, references(:blog_categories)

      timestamps
    end
  end
end
