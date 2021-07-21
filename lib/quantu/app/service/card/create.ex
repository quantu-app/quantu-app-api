defmodule Quantu.App.Service.Card.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:deck, Model.Deck, type: :binary_id)
    field(:front, {:array, :map}, null: false, default: [])
    field(:back, {:array, :map}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:deck_id, :front, :back])
    |> validate_required([
      :deck_id,
      :front,
      :back
    ])
    |> foreign_key_constraint(:deck_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Card{}
      |> cast(command, [:deck_id, :front, :back])
      |> validate_required([
        :deck_id,
        :front,
        :back
      ])
      |> Repo.insert!()
    end)
  end
end
