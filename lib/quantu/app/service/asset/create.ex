defmodule Quantu.App.Service.Asset.Create do
  use Aicacia.Handler
  use Waffle.Ecto.Schema

  alias Quantu.App.{Model, Repo, Web.Uploader}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:parent, Model.Asset)
    field(:name, Uploader.Asset.Type, null: false)
    field(:type, :string, null: false)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :parent_id, :type])
    |> put_change(:name, Map.get(attrs, :name, Map.get(attrs, "name")))
    |> validate_required([
      :organization_id
    ])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:parent_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :type) == "folder" do
        %Model.Asset{}
        |> cast(command, [:organization_id, :parent_id, :type])
        |> put_change(:name, Map.get(command, :name))
        |> put_change(:type, "folder")
        |> Repo.insert!()
      else
        changeset =
          %Model.Asset{}
          |> cast(command, [:organization_id, :parent_id])
          |> Repo.insert!()
          |> cast_attachments(command, [:name], allow_urls: true)

        %{file_name: file_name} = get_field(changeset, :name)
        changeset = put_change(changeset, :type, MIME.from_path(file_name))

        Repo.update!(changeset)
      end
    end)
  end
end
