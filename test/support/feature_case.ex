defmodule BlogApp.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias BlogApp.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import BlogApp.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BlogApp.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(BlogApp.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(BlogApp.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
