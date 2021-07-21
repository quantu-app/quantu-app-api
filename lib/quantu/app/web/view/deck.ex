defmodule Quantu.App.Web.View.Deck do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Deck

  def render("index.json", %{decks: decks}),
    do: render_many(decks, Deck, "deck.json")

  def render("show.json", %{deck: deck}),
    do: render_one(deck, Deck, "deck.json")

  def render("deck.json", %{deck: deck}),
    do: %{
      id: deck.id,
      userId: deck.user_id,
      name: deck.name,
      tags: deck.tags,
      insertedAt: deck.inserted_at,
      updatedAt: deck.updated_at
    }
end
