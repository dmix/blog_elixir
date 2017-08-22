# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BlogApp.Repo
alias BlogApp.Accounts.Role
alias BlogApp.Accounts.User
alias BlogApp.Blog
alias BlogApp.Blog.Category
alias BlogApp.Blog.Post
# alias BlogApp.Blog.PostCategory

import Ecto.Query, only: [from: 2]

# Find or Create Methods
# ----------------------------------------------------------------------------

find_or_create_role = fn role ->
  query = from r in Role,
          where: r.name == ^role.name and r.admin == ^role.admin
  if !Repo.one(query) do
    Repo.insert(role)
  end
  Repo.one(query)
end

find_or_create_user = fn user ->
  query = from u in User,
          where: u.username == ^user.username and u.email == ^user.email
  if !Repo.one(query) do
    %User{}
      |> User.changeset(user)
      |> Repo.insert()
  end
  Repo.one(query)
end

find_or_create_category = fn category ->
  query = from c in Category,
          where: c.name == ^category.name and c.permalink == ^category.permalink
  if !Repo.one(query) do
    Repo.insert(category)
  end
  Repo.one(query)
end

find_or_create_post = fn post ->
  query = from p in Post,
          where: p.permalink == ^post.permalink and p.title == ^post.title
  if !Repo.one(query) do
    Repo.insert(post)
  end
  Repo.one(query)
end

# Create Roles
# ----------------------------------------------------------------------------

IO.puts "Creating Roles..."

_user_role  = find_or_create_role.(%Role{name: "User Role",  admin: false})
admin_role  = find_or_create_role.(%Role{name: "Admin Role", admin: true})

# Create Admins
# ----------------------------------------------------------------------------

IO.puts "Creating Admins..."

_admin_user = find_or_create_user.(%{
  username: "admin", 
  email: "admin@test.com", 
  bio: "My bio", 
  name: "Admin", 
  password: "test", 
  password_confirmation: "test", 
  role_id: admin_role.id
})

dmix_user = find_or_create_user.(%{
  username: "dmix", 
  email: "dan@dmix.ca", 
  bio: "My bio", 
  name: "Dan McGrady", 
  password: "test", 
  password_confirmation: "test", 
  role_id: admin_role.id
})

# Create Categories
# ----------------------------------------------------------------------------

IO.puts "Creating Categories..."

categories = [
  %Category{name: "Startups",   permalink: "startups",   description: "This is an example description", icon: "book"},
  %Category{name: "UX Design",  permalink: "ux_design",  description: "This is an example description", icon: "book"},
  %Category{name: "Toronto",    permalink: "toronto",    description: "This is an example description", icon: "book"},
  %Category{name: "Elixir",     permalink: "elixir",     description: "This is an example description", icon: "book"},
  %Category{name: "Javascript", permalink: "javascript", description: "This is an example description", icon: "book"}
]

Enum.map(categories, find_or_create_category)


# Create Posts
# ----------------------------------------------------------------------------
post_1 = find_or_create_post.(%Post{
    title: Enum.join(Faker.Lorem.words(%Range{first: 1, last: 8}), " "),
    permalink: Faker.Internet.slug,
    body: Enum.join(Faker.Lorem.paragraphs(%Range{first: 5, last: 10}), "<br>"
})
Blog.append_categories(post_1, ["Startups"])

