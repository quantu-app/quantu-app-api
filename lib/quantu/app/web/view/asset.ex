defmodule Quantu.App.Web.View.Asset do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Asset

  def render("index.json", %{assets: assets}),
    do: render_many(assets, Asset, "asset.json")

  def render("show.json", %{asset: asset}),
    do: render_one(asset, Asset, "asset.json")

  def render("asset.json", %{asset: asset}) do
    %{
      id: asset.id,
      organizationId: asset.organization_id,
      parentId: asset.parent_id,
      name: asset.name.file_name,
      url:
        Path.join([
          "static",
          "assets",
          to_string(asset.organization_id),
          to_string(asset.parent_id),
          to_string(asset.id)
        ]),
      type: asset.type,
      insertedAt: asset.inserted_at,
      updatedAt: asset.updated_at
    }
  end
end
