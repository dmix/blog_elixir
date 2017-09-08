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
alias BlogApp.Blog.Comment

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

find_or_create_comment = fn comment ->
  query = from p in Comment,
          where: p.author == ^comment.author and p.body == ^comment.body
  if !Repo.one(query) do
    Repo.insert(comment)
  end
  Repo.one(query)
end

IO.puts "Ecto: Seeding Database"

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

new_category = fn name, permalink ->
  %Category{
    name: name,
    permalink: permalink,
    description: "This is an example description",
    icon: "book"
  }
end

categories = [
  new_category.("Startups",   "startups"),
  new_category.("UX Design",  "ux_design"),
  new_category.("Toronto",    "toronto"),
  new_category.("Elixir",     "elixir"),
  new_category.("Javascript", "javascript")
]

Enum.map(categories, find_or_create_category)


# Create Posts
# ----------------------------------------------------------------------------

new_post = fn ->
  body = """
  <p>
  #{Faker.Lorem.paragraphs(%Range{first: 1, last: 4})}</p> <p>
  #{Faker.Lorem.paragraphs(%Range{first: 1, last: 4})}</p> <p>
  #{Faker.Lorem.paragraphs(%Range{first: 1, last: 4})}</p> <p>
  #{Faker.Lorem.paragraphs(%Range{first: 1, last: 4})}</p>
  """
  %Post{
      title: String.capitalize(Enum.join(Faker.Lorem.words(%Range{first: 1, last: 8}), " ")),
      permalink: Faker.Internet.slug,
      body: body,
      user: dmix_user
  }
end

post_1 = find_or_create_post.(new_post.())
post_2 = find_or_create_post.(new_post.())
post_3 = find_or_create_post.(new_post.())
post_4 = find_or_create_post.(new_post.())
post_5 = find_or_create_post.(new_post.())

# Create Post Categories
# ----------------------------------------------------------------------------

IO.puts "Creating Post Categories..."

Blog.append_categories(post_1, ["Startups"])
Blog.append_categories(post_1, ["Toronto"])
Blog.append_categories(post_2, ["Startups"])
Blog.append_categories(post_3, ["Toronto"])
Blog.append_categories(post_4, ["UX Design"])
Blog.append_categories(post_5, ["Elixir"])

# Create Comments
# ----------------------------------------------------------------------------

IO.puts "Creating Comments..."

new_comment = fn post, approved ->
  %Comment{
    body: Enum.join(Faker.Lorem.paragraphs(%Range{first: 1, last: 2}), "<br>"),
    author: Faker.Internet.user_name,
    approved: approved,
    post_id: post.id
  }
end

comment_1 = find_or_create_comment.(new_comment.(post_1, true))
comment_2 = find_or_create_comment.(new_comment.(post_1, true))
comment_3 = find_or_create_comment.(new_comment.(post_1, true))
comment_4 = find_or_create_comment.(new_comment.(post_1, false))
comment_5 = find_or_create_comment.(new_comment.(post_2, true))

IO.puts "Done"
