defmodule Quantu.App.Service.Deck.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:name, :string, null: false)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :name, :tags])
    |> validate_required([
      :user_id,
      :name
    ])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Deck{}
      |> cast(command, [:user_id, :name, :tags])
      |> validate_required([
        :user_id,
        :name
      ])
      |> Repo.insert!()
    end)
  end
end
