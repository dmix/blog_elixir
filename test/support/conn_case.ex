defmodule BlogApp.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

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
      import Plug.Conn
      import BlogApp.Factory
      import BlogApp.Web.Router.Helpers
      import Comeonin.Argon2, only: [checkpw: 2]

      alias Plug.Conn
      # The default endpoint for testing
      @endpoint BlogApp.Web.Endpoint

      @session Plug.Session.init(
        store: :cookie,
        key: "_app",
        encryption_salt: "yadayada",
        signing_salt: "yadayada"
      )

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
