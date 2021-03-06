defmodule Quantu.App.Service.Organization.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string)
    field(:url, :string)
    field(:tags, {:array, :string})
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :organization_id,
      :user_id,
      :name,
      :url,
      :tags
    ])
    |> Service.Organization.Create.url_from_name()
    |> validate_format(:url, Service.Organization.Create.url_regex())
    |> validate_required([:organization_id, :user_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Organization, id: command.organization_id, user_id: command.user_id)
      |> cast(command, [:name, :url, :tags])
      |> unique_constraint(:url)
      |> Repo.update!()
    end)
  end
end
