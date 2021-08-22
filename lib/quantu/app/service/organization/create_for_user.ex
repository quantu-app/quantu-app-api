defmodule Quantu.App.Service.Organization.CreateForUser do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo, Service, Util}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string)
    field(:url, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :name, :url])
    |> name_and_url_from_user()
    |> validate_required([
      :user_id,
      :name,
      :url
    ])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Service.Organization.Create.handle(command)
  end

  def name_and_url_from_user(changeset) do
    case get_field(changeset, :user_id) do
      nil ->
        changeset

      user_id ->
        case Repo.get(Model.User, user_id) do
          nil ->
            changeset
          %Model.User{username: username} ->
            changeset
            |> put_change(:url, unique_url(username))
            |> put_change(:name, username)
        end
    end
  end

  def unique_url(url) do
    case Repo.get_by(Model.Organization, url: url) do
      nil ->
        url
      %Model.Organization{} ->
        unique_url(url <> Util.generate_token(4))
    end
  end
end
