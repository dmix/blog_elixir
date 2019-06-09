defmodule BlogAppWeb.Router do
  use BlogAppWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BlogAppWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)
    get("/projects", PageController, :projects)

    resources("/blog", PostController, only: [:index])
    resources("/blog/:category", PostController, only: [:index])

    resources("/comments", CommentController, only: [:index])

    resources "/blog", PostController, only: [] do
      resources("/comments", CommentController)
    end

    resources("/categories", CategoryController)

    resources "/users", UserController, except: [:show] do
      resources("/blog", PostController)
    end

    resources("/sessions", SessionController, only: [:new, :create, :delete])
    get("/login", SessionController, :new)

    get("/:permalink", PostController, :show)
  end
end
