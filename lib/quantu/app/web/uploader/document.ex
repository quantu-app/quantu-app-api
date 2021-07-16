defmodule Quantu.App.Web.Uploader.Document do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]

  def bucket, do: "quantu-app-documents"

  def validate({file, _}), do: ~w(.doc) |> Enum.member?(Path.extname(file.file_name))

  def storage_dir(_version, {_file, scope}), do: "#{scope.user_id}"
end
