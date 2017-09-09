ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(BlogApp.Repo, :manual)
Application.put_env(:wallaby, :base_url, BlogApp.Web.Endpoint.url)

{:ok, _} = Application.ensure_all_started(:ex_machina)
# {:ok, _} = Application.ensure_all_started(:wallaby)
