defmodule Quantu.App.Service.Asset.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo, Web.Uploader}

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
      asset = Repo.get!(Model.Asset, command.asset_id)
      Repo.delete!(asset)

      if asset.type != "folder" do
        :ok = Uploader.Asset.delete({asset.name, asset})
      end

      asset
    end)
  end
end
