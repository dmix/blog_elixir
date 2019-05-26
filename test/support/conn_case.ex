defmodule BlogAppWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias BlogAppWeb.Router.Helpers, as: Routes
      import BlogApp.Factory

      # The default endpoint for testing
      @endpoint BlogAppWeb.Endpoint

      # Authentication
      @session Plug.Session.init(
                 store: :cookie,
                 key: "_app",
                 encryption_salt: "yadayada",
                 signing_salt: "yadayada"
               )

      def login_admin do
        user = insert(:user, role: insert(:role))
        session_data = %{id: user.id, username: user.username, role_id: user.role_id}

        conn =
          build_conn(:get, "/")
          |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
          |> Plug.Session.call(@session)
          |> Conn.fetch_session()
          |> Conn.put_session(:current_user, session_data)

        {:ok, conn: conn, session_data: session_data, user: user}
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BlogApp.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(BlogApp.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
