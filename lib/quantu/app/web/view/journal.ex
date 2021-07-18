defmodule Quantu.App.Web.View.Journal do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Journal

  def render("index.json", %{journals: journals}),
    do: render_many(journals, Journal, "journal.json")

  def render("show.json", %{journal: journal}),
    do: render_one(journal, Journal, "journal.json")

  def render("journal.json", %{journal: journal}),
    do: %{
      id: journal.id,
      userId: journal.user_id,
      name: journal.name,
      content: journal.content,
      location: journal.location,
      language: journal.language,
      wordCount: journal.word_count,
      tags: journal.tags,
      insertedAt: journal.inserted_at,
      updatedAt: journal.updated_at
    }
end
