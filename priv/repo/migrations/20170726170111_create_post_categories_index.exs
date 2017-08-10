defmodule BlogApp.Repo.Migrations.CreatePostCategoriesIndex do
  use Ecto.Migration

  def change do
    create unique_index(:blog_post_categories, [:post_id, :category_id], name: :post_categories_id_index)
  end
end
