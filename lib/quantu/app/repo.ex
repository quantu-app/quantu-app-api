defmodule Quantu.App.Repo do
  use Ecto.Repo,
    otp_app: :quantu_app,
    adapter: Ecto.Adapters.Postgres

  def run(fun_or_multi, opts \\ []) do
    try do
      Quantu.App.Repo.transaction(fun_or_multi, opts)
    rescue
      e -> {:error, e}
    end
  end
end
