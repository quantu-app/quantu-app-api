defmodule Quantu.App.Service.Card.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:deck, Model.Deck, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:deck_id])
    |> validate_required([:deck_id])
    |> foreign_key_constraint(:deck_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      from(b in Model.Card,
        where:
          b.deck_id ==
            ^command.deck_id
      )
      |> Repo.all()
    end)
  end
end
