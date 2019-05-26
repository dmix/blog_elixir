# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blog_app,
  ecto_repos: [BlogApp.Repo]

# Configures the endpoint
config :blog_app, BlogAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pZHId2HCRpjKK1VAmlSPZ/ytOwDFNYqOON0OygKp8GNadTX9S+AySQxsxhfttYfU",
  render_errors: [view: BlogAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlogApp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_active_link, :defaults,
  class_active: "active   button link black b--black-05 b ba br1 f6 f5-ns dib w-100 pv3 ph4",
  class_inactive: "inactive button link black b--black-05   ba br1 f6 f5-ns dib w-100 pv3 ph4",
  active: :inclusive

if Mix.env() == :dev do
  config :mix_test_watch,
    clear: true,
    tasks: [
      "test",
      "credo"
    ],
    exclude: [
      ~r/priv\/.*/,
      ~r/db_migration\/.*/,
      ~r/rel\/.*/,
      ~r/bin\/.*/,
      ~r/_build\/.*/,
      ~r/deps\/.*/,
      ~r/assets\/.*/
    ]
end

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :phoenix_slime, :use_slim_extension, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
