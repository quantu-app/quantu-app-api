defmodule Quantu.App.Service.Asset.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:asset, Model.Asset)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:asset_id])
    |> validate_required([:asset_id])
    |> foreign_key_constraint(:asset_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Asset, command.asset_id)
    end)
  end
end
