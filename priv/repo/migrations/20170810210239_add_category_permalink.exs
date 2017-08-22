defmodule BlogApp.Repo.Migrations.AddCategoryPermalink do
  use Ecto.Migration

  def change do
    alter table(:blog_categories) do
      add :permalink, :string
    end
  end
end
