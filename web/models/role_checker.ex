defmodule Blog.RoleChecker do
  alias Blog.Repo
  alias Blog.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
