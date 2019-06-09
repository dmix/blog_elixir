# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

# import BlogApp.Factory

alias BlogApp.Repo
alias BlogApp.Accounts
alias BlogApp.Blog

IO.puts("Starting app...")
Mix.Task.run("app.start")

IO.puts("Cleaning DB...")

Repo.delete_all(Blog.PostCategory)
Repo.delete_all(Blog.Category)
Repo.delete_all(Blog.Comment)
Repo.delete_all(Blog.Post)
Repo.delete_all(Accounts.User)

IO.puts("Generating data...")

{:ok, role} =
  Accounts.create_role(%{
    admin: true,
    name: "admin"
  })

{:ok, user} =
  Accounts.create_user(%{
    email: "dan@dmix.ca",
    username: "dmix",
    password: "test",
    password_confirmation: "test",
    name: "Dan McGrady",
    bio: "Hi im a front-end software developer. I made some
     \ comments earlier about some issues with commenting
     \ (links = all white).",
    role_id: role.id
  })

categories = [
  {"Design", "design"},
  {"Programming", "programming"},
  {"Elixir", "Elixir"},
  {"Ruby", "ruby"},
  {"UX", "ux"},
  {"Analytics", "analytics"}
]

category_list =
  Enum.map(categories, fn {name, permalink} ->
    {:ok, c} =
      Blog.create_category(%{
        name: name,
        permalink: permalink,
        description: Faker.Lorem.sentence(%Range{first: 1, last: 3}),
        icon: "check"
      })

    c
  end)

Enum.each(0..20, fn _x ->
  {:ok, post} =
    Blog.create_post(user, %{
      title: Enum.join(Faker.Lorem.words(%Range{first: 1, last: 8}), " "),
      permalink: Faker.Internet.slug(),
      body: Enum.join(Faker.Lorem.paragraphs(%Range{first: 5, last: 10}), "</p> <p>")
    })

  {:ok, _} = Blog.create_post_category(post, Enum.random(category_list))

  Enum.each(0..3, fn _y ->
    {:ok, _} =
      Blog.create_comment(post.id, %{
        approved: true,
        author: Faker.Internet.user_name(),
        body: Faker.Lorem.sentence()
      })
  end)
end)

IO.puts("Done.")
