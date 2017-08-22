defmodule BlogApp.Repo.Migrations.ModifyCommentsBodyText do
  use Ecto.Migration

  def change do
    alter table(:blog_comments) do
      modify :body, :text
    end
  end
end
