defmodule BlogApp.Web.Repo.Migrations.AddFieldsToPost do
  use Ecto.Migration

  def change do
    alter table(:blog_posts) do
      modify :body, :text
      add :permalink, :string
      add :categories, {:array, :string}
    end
  end
end
