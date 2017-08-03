defmodule BlogApp.Web.Repo.Migrations.RenamePostCategories do
  use Ecto.Migration

  def change do
    rename table(:blog_posts_categories), to: table(:blog_post_categorie)

    alter table(:blog_posts) do
      remove :categories
    end
  end
end
