defmodule BlogApp.Repo.Migrations.RenamePostCategoriesIds do
  use Ecto.Migration

  def change do
    rename table(:blog_post_categories), :blog_post_id, to: :post_id
    rename table(:blog_post_categories), :blog_category_id, to: :category_id
  end
end
