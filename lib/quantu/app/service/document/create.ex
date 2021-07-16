defmodule Quantu.App.Service.Document.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string, null: false)
    field(:type, :string, null: false)
    field(:language, :string, null: false, default: "en")
    field(:word_count, :integer, null: false, default: 0)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :name, :type, :language, :word_count, :tags])
    |> validate_required([
      :user_id,
      :name,
      :type,
      :language,
      :word_count,
      :tags
    ])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Document{}
      |> cast(command, [
        :user_id,
        :name,
        :type,
        :language,
        :word_count,
        :tags
      ])
      |> validate_required([
        :user_id,
        :name,
        :type,
        :language,
        :word_count,
        :tags
      ])
      |> Repo.insert!()
    end)
  end
end
