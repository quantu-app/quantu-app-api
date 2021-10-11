defmodule Quantu.App.Web.Uploader.Asset do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @acl :public_read

  def prefix,
    do:
      if(
        Application.get_env(:waffle, :storage) == Waffle.Storage.Local,
        do:
          Path.join([
            "priv",
            "static",
            "assets",
            to_string(Mix.env())
          ]),
        else:
          Path.join([
            "assets",
            to_string(Mix.env())
          ])
      )

  def storage_dir(_version, {_file, asset}),
    do:
      if(asset.parent_id == nil,
        do: Path.join([prefix(), to_string(asset.organization_id)]),
        else: Path.join([prefix(), to_string(asset.organization_id), to_string(asset.parent_id)])
      )

  def filename(version, {file, asset}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    Path.join([to_string(asset.id), "#{version}_#{file_name}"])
  end

  def s3_object_headers(_version, {file, _asset}),
    do: [content_type: MIME.from_path(file.file_name)]

  def local_filepath({file, asset}, version \\ :original) do
    Path.join([
      storage_dir(version, {file, asset}),
      filename(version, {file, asset}) <> Path.extname(file.file_name)
    ])
  end
end
