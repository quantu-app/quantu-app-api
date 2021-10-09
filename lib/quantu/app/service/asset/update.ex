defmodule Quantu.App.Service.Asset.Update do
  use Aicacia.Handler
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Repo, Web.Uploader}

  @primary_key false
  schema "" do
    belongs_to(:asset, Model.Asset)
    belongs_to(:parent, Model.Asset)
    field(:name, Uploader.Asset.Type, null: false)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:asset_id, :parent_id])
    |> put_change(:name, Map.get(attrs, :name, Map.get(attrs, "name")))
    |> validate_required([:asset_id])
    |> foreign_key_constraint(:asset_id)
    |> foreign_key_constraint(:parent_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      asset = Repo.get_by!(Model.Asset, id: command.asset_id)

      if asset.type == "folder" do
        asset
        |> cast(command, [:parent_id, :name])
        |> Repo.update!()
      else
        changeset =
          asset
          |> cast(command, [:parent_id])
          |> cast_attachments(command, [:name], allow_urls: true)

        %{file_name: file_name} = get_field(changeset, :name)
        changeset = put_change(changeset, :type, MIME.from_path(file_name))

        new_asset = Repo.update!(changeset)

        if new_asset.name != asset.name do
          :ok = Uploader.Asset.delete({asset.name, asset})
        end

        new_asset
      end
    end)
  end
end
