defmodule BlogApp.Repo.Migrations.CreateBlogApp.Accounts.Role do
  use Ecto.Migration

  def change do
    create table(:accounts_roles) do
      add :name, :string
      add :admin, :boolean, default: false, null: false

      timestamps()
    end

  end
end
