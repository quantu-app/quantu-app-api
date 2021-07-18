defmodule Quantu.App.Service.Journal.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:journal, Model.Journal, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string)
    field(:content, {:array, :map})
    field(:location, :string)
    field(:language, :string)
    field(:word_count, :integer)
    field(:tags, {:array, :string})
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :journal_id,
      :user_id,
      :name,
      :content,
      :location,
      :language,
      :word_count,
      :tags
    ])
    |> validate_required([:journal_id, :user_id])
    |> foreign_key_constraint(:journal_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Journal, id: command.journal_id, user_id: command.user_id)
      |> cast(command, [:name, :content, :location, :language, :word_count, :tags])
      |> Repo.update!()
    end)
  end
end
