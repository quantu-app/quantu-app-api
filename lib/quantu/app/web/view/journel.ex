defmodule Quantu.App.Web.View.Journel do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Journel

  def render("index.json", %{journels: journels}),
    do: render_many(journels, Journel, "journel.json")

  def render("show.json", %{journel: journel}),
    do: render_one(journel, Journel, "journel.json")

  def render("journel.json", %{journel: journel}),
    do: %{
      id: journel.id,
      userId: journel.user_id,
      name: journel.name,
      content: journel.content,
      location: journel.location,
      language: journel.language,
      wordCount: journel.word_count,
      tags: journel.tags,
      insertedAt: journel.inserted_at,
      updatedAt: journel.updated_at
    }
end
