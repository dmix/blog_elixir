defmodule BlogApp.Web.Router do
  use BlogApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogApp.Web do
    pipe_through :browser # Use the default browser stack

    get "/",         PageController, :index
    get "/about",    PageController, :about
    get "/projects", PageController, :projects

    resources "/blog", PostController, only: [:index]
    resources "/blog/:category", PostController, only: [:index]

    resources "/comments", CommentController, only: [:index]
    resources "/blog", PostController, only: [] do
      resources "/comments", CommentController
    end

    resources "/categories", CategoryController

    resources "/users", UserController do
      resources "/blog", PostController
    end

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/:permalink", PostController, :show
  end

end
