[
  mappings: [
    "logger.console.format": [
      doc: "Provide documentation for logger.console.format here.",
      to: "logger.console.format",
      datatype: :binary,
      default: """
      $time $metadata[$level] $message
      """
    ],
    "logger.console.metadata": [
      doc: "Provide documentation for logger.console.metadata here.",
      to: "logger.console.metadata",
      datatype: [
        list: :atom
      ],
      default: [
        :request_id
      ]
    ],
    "logger.level": [
      doc: "Provide documentation for logger.level here.",
      to: "logger.level",
      datatype: :atom,
      default: :info
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.root": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.root here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.root",
      datatype: :binary,
      default: "/Users/brichey/Documents/dev/phoenix/blog"
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.render_errors.accepts": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.render_errors.accepts here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.render_errors.accepts",
      datatype: [
        list: :binary
      ],
      default: [
        "html",
        "json"
      ]
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.pubsub.name": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.pubsub.name here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.pubsub.name",
      datatype: :atom,
      default: BlogAppWeb.Pubsub
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.pubsub.adapter": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.pubsub.adapter here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.pubsub.adapter",
      datatype: :atom,
      default: Phoenix.PubSub.PG2
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.http.port": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.http.port here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.http.port",
      datatype: :binary,
      default: nil
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.url.host": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.url.host here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.url.host",
      datatype: :binary,
      default: "example.com"
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.url.port": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.url.port here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.url.port",
      datatype: :integer,
      default: 80
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.cache_static_manifest": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.cache_static_manifest here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.cache_static_manifest",
      datatype: :binary,
      default: "priv/static/manifest.json"
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.server": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.server here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.server",
      datatype: :atom,
      default: true
    ],
    "blog.Elixir.BlogAppWeb.Endpoint.secret_key_base": [
      doc: "Provide documentation for blog.Elixir.BlogAppWeb.Endpoint.secret_key_base here.",
      to: "blog.Elixir.BlogAppWeb.Endpoint.secret_key_base",
      datatype: :binary,
      default: "fmEw9VvdugAYE+2kNnWz5OgB99A0PW/bmVwlC9wm9To8FBfKP2rKiaaIPfgf6adq"
    ],
    "blog.Elixir.BlogApp.Repo.adapter": [
      doc: "Provide documentation for blog.Elixir.BlogApp.Repo.adapter here.",
      to: "blog.Elixir.BlogApp.Repo.adapter",
      datatype: :atom,
      default: Ecto.Adapters.Postgres
    ],
    "blog.Elixir.BlogApp.Repo.username": [
      doc: "Provide documentation for blog.Elixir.BlogApp.Repo.username here.",
      to: "blog.Elixir.BlogApp.Repo.username",
      datatype: :binary,
      default: "postgres"
    ],
    "blog.Elixir.BlogApp.Repo.password": [
      doc: "Provide documentation for blog.Elixir.BlogApp.Repo.password here.",
      to: "blog.Elixir.BlogApp.Repo.password",
      datatype: :binary,
      default: "postgres"
    ],
    "blog.Elixir.BlogApp.Repo.database": [
      doc: "Provide documentation for blog.Elixir.BlogApp.Repo.database here.",
      to: "blog.Elixir.BlogApp.Repo.database",
      datatype: :binary,
      default: "blog_prod"
    ],
    "blog.Elixir.BlogApp.Repo.pool_size": [
      doc: "Provide documentation for blog.Elixir.BlogApp.Repo.pool_size here.",
      to: "blog.Elixir.BlogApp.Repo.pool_size",
      datatype: :integer,
      default: 20
    ],
    "comeonin.bcrypt_log_rounds": [
      doc: "Provide documentation for comeonin.bcrypt_log_rounds here.",
      to: "comeonin.bcrypt_log_rounds",
      datatype: :integer,
      default: 14
    ],
    "phoenix.generators.migration": [
      doc: "Provide documentation for phoenix.generators.migration here.",
      to: "phoenix.generators.migration",
      datatype: :atom,
      default: true
    ],
    "phoenix.generators.binary_id": [
      doc: "Provide documentation for phoenix.generators.binary_id here.",
      to: "phoenix.generators.binary_id",
      datatype: :atom,
      default: false
    ]
  ],
  translations: [
  ]
]
