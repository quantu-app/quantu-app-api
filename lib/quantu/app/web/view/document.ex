defmodule Quantu.App.Web.View.Document do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Document

  def render("index.json", %{documents: documents}),
    do: render_many(documents, Document, "document.json")

  def render("show.json", %{document: document}),
    do: render_one(document, Document, "document.json")

  def render("document.json", %{document: document}),
    do: %{
      id: document.id,
      userId: document.user_id,
      name: document.name,
      type: document.type,
      contentHash: document.content_hash,
      language: document.language,
      wordCount: document.word_count,
      tags: document.tags,
      insertedAt: document.inserted_at,
      updatedAt: document.updated_at
    }
end
