# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BlogApp.Repo.insert!(%BlogApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BlogApp.Repo
alias BlogApp.Accounts
alias BlogApp.Accounts.Role
alias BlogApp.Accounts.User
alias BlogApp.Blog
alias BlogApp.Blog.Comment
alias BlogApp.Blog.Category
alias BlogApp.Blog.Post
alias BlogApp.Blog.PostCategory

Accounts.create_user(%{
})

Accounts.create_role(%{
})

Blog.create_category(${
})

Blog.create_post(${
})

Blog.create_post_category(${
})

Blog.create_comment(${
})

# accounts
# - user
# - role
# blog
# - category
# - post
# - post categories
# - comments
