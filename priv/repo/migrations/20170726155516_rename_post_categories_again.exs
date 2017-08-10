defmodule BlogApp.Repo.Migrations.RenamePostCategoriesAgain do
  use Ecto.Migration

  def change do
    rename table(:blog_post_categorie), to: table(:blog_post_categories)
  end
end
