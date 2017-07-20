defmodule BlogApp.Web.Repo.Migrations.CreateBlogApp.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :username, :string
      add :email, :string
      add :password_digest, :string
      add :role_id, references(:accounts_roles, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts_users, [:role_id])
  end
end
