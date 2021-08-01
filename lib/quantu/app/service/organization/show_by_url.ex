defmodule Quantu.App.Service.Organization.ShowByUrl do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    field(:url, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:url])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Organization, url: command.url)
    end)
  end
end
