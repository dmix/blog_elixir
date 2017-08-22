#use Mix.Task

alias BlogApp.Repo
alias BlogApp.Blog
alias BlogApp.Accounts

IO.puts "Starting app..."
Mix.Task.run "app.start"

IO.puts "Cleaning DB..."

Repo.delete_all(Blog.PostCategory)
Repo.delete_all(Blog.Category)
Repo.delete_all(Blog.Comment)
Repo.delete_all(Blog.Post)
Repo.delete_all(Accounts.User)

IO.puts "Done."
