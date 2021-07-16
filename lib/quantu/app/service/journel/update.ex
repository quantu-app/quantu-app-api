defmodule Quantu.App.Service.Journel.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:journel, Model.Journel, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string, null: false)
    field(:content, {:array, :map}, null: false, default: [])
    field(:language, :string, null: false, default: "en")
    field(:word_count, :integer, null: false, default: 0)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:journel_id, :user_id, :name, :content, :language, :word_count, :tags])
    |> validate_required([:journel_id, :user_id])
    |> foreign_key_constraint(:journel_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Journel, id: command.journel_id, user_id: command.user_id)
      |> cast(command, [:name, :language, :word_count, :tags])
      |> Repo.update!()
    end)
  end
end
