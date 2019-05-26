defmodule BlogApp.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: BlogApp.Repo

  alias BlogApp.Accounts
  alias BlogApp.Blog

  def role_factory do
    %Accounts.Role{
      admin: true,
      name: Faker.Name.title()
    }
  end

  def user_factory do
    %Accounts.User{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: "test",
      password_confirmation: "test",
      name: Faker.Name.name(),
      bio: Faker.Name.title(),
      role: build(:role)
    }
  end

  def category_factory do
    %Blog.Category{
      name: String.capitalize(Faker.Lorem.word()),
      permalink: Faker.Internet.slug(),
      description: Faker.Lorem.sentence(%Range{first: 5, last: 10}),
      icon: Faker.Internet.slug()
    }
  end

  def comment_factory do
    %Blog.Comment{
      approved: true,
      author: Faker.Internet.user_name(),
      body: Faker.Lorem.sentence(),
      post: build(:post)
    }
  end

  def post_factory do
    %Blog.Post{
      title: Enum.join(Faker.Lorem.words(%Range{first: 1, last: 8}), " "),
      permalink: Faker.Internet.slug(),
      body: Enum.join(Faker.Lorem.paragraphs(%Range{first: 5, last: 10}), "<br>"),
      user: build(:user)
    }
  end

  def post_category_factory do
    %Blog.PostCategory{
      category: build(:category),
      post: build(:post)
    }
  end
end
