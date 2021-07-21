defmodule Quantu.App.Service.Card.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:card, Model.Card)
    belongs_to(:deck, Model.Deck, type: :binary_id)
    field(:front, {:array, :map})
    field(:back, {:array, :map})
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :card_id,
      :deck_id,
      :front,
      :back
    ])
    |> validate_required([:card_id, :deck_id])
    |> foreign_key_constraint(:card_id)
    |> foreign_key_constraint(:deck_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Card, id: command.card_id, deck_id: command.deck_id)
      |> cast(command, [:front, :back])
      |> Repo.update!()
    end)
  end
end
