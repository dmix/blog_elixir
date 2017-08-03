defmodule BlogApp.Web.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:accounts_users) do
      add :primary,      :boolean
      add :name,         :string
      add :bio,          :string
      add :avatar_url,   :string

      add :twitter_url,  :string
      add :github_url,   :string
      add :linkedin_url, :string
      add :dribbble_url, :string
    end
  end
end
