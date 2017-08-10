defmodule BlogApp.Mixfile do
  use Mix.Project

  def project do
    [app: :blog_app,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {BlogApp.Application, []},
     extra_applications: [:logger, :runtime_tools, :comeonin, :ex_machina]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, "~> 0.13"},
     {:phoenix_html, "~> 2.10"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix_active_link, "~> 0.1"},
     {:gettext, "~> 0.13"},
     {:cowboy, "~> 1.1"},
     {:comeonin, "~> 4.0"},
     {:argon2_elixir, "~> 1.2"},
     {:ex_machina, "~> 2.0"},
     {:earmark, "~> 1.2"},
     {:distillery, "~> 1.4", runtime: false},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
      "deploy": [
        "mix release", # distillery
      ]
    ]
  end
end
