defmodule Quantu.App.Web.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      alias Quantu.App.Web.Router.Helpers, as: Routes

      @endpoint Quantu.App.Web.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Quantu.App.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Quantu.App.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
