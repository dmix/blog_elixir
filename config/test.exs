use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_app, :sql_sandbox, true
config :blog_app, BlogApp.Web.Endpoint,
  http: [port: 4001],
  server: true

# Configure your database
config :blog_app, BlogApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "blog_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
