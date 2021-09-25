defmodule Quantu.App.Service.Organization.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @url_regex ~r/[a-zA-Z0-9\-_]+/i
  @replace_regex ~r/[^a-zA-Z0-9\-_]+/i
  @spaces_regex ~r/\s+/i

  def url_regex, do: @url_regex

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string, null: false)
    field(:url, :string)
    field(:tags, {:array, :string})
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :name, :url, :tags])
    |> url_from_name()
    |> validate_required([
      :user_id,
      :name,
      :url
    ])
    |> validate_format(:url, @url_regex)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.User, id: command.user_id, creator: true)

      %Model.Organization{}
      |> cast(command, [:user_id, :name, :url, :tags])
      |> unique_constraint(:url)
      |> Repo.insert!()
    end)
  end

  def url_from_name(changeset) do
    case get_field(changeset, :url) do
      nil ->
        case get_field(changeset, :name) do
          nil ->
            changeset

          name ->
            url = Regex.replace(@replace_regex, String.downcase(name), " ") |> String.trim()
            url = Regex.replace(@spaces_regex, url, "-")
            put_change(changeset, :url, url)
        end

      _url ->
        changeset
    end
  end
end
