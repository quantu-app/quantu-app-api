defmodule Quantu.App.Web.View.Card do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Card

  def render("index.json", %{cards: cards}),
    do: render_many(cards, Card, "card.json")

  def render("show.json", %{card: card}),
    do: render_one(card, Card, "card.json")

  def render("card.json", %{card: card}),
    do: %{
      id: card.id,
      deckId: card.deck_id,
      front: card.front,
      back: card.back,
      insertedAt: card.inserted_at,
      updatedAt: card.updated_at
    }
end
