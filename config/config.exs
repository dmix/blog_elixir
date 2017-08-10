# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blog_app,
  ecto_repos: [BlogApp.Repo]

# Configures the endpoint
config :blog_app, BlogApp.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/WBEf0t0wHXs8HkJJsb+X0Y7AYKS4OepyPXnLzy83s+POdwDhyy0Kv0hZys4t9TG",
  render_errors: [view: BlogApp.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlogApp.Web.Pubsub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :phoenix_active_link, :defaults,
  class_active:   "btn btn-primary active",
  class_inactive: "btn btn-outline inactive",
  active: :inclusive
