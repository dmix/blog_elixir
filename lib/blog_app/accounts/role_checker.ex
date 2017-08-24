defmodule BlogApp.Accounts.RoleChecker do
  alias BlogApp.Repo
  alias BlogApp.Accounts.Role

  @spec is_admin?(Ecto.Repo.t) :: boolean
  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
