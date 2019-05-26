defmodule BlogApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :blog_app,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BlogApp.Application, []},
      extra_applications: [:logger, :runtime_tools, :comeonin, :ex_machina, :faker]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Framework
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      # User packages
      {:phoenix_active_link, "~> 0.2.1"},
      {:phoenix_slime, "~> 0.11"},
      {:html_sanitize_ex, "~> 1.3"},
      {:timex, "~> 3.5"},
      {:argon2_elixir, "~> 2.0"},
      {:ex_machina, "~> 2.3"},
      {:earmark, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:distillery, "~> 2.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.9", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:faker, "~> 0.12", only: [:dev, :test]},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:wallaby, "~> 0.22.0", only: [:test]}
    ]
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
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      # distillery
      deploy: "release",
      dev: "test.watch",
      routes: "phx.routes BlogAppWeb.Router",
      s: "phx.server"
    ]
  end
end
