defmodule Quantu.App.Web.View.Email do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Email

  def render("index.json", %{emails: emails}), do: render_many(emails, Email, "email.json")

  def render("show.json", %{email: email}), do: render_one(email, Email, "email.json")

  def render("email.json", %{email: email}),
    do: %{
      id: email.id,
      userId: email.user_id,
      email: email.email,
      confirmed: email.confirmed,
      primary: email.primary,
      insertedAt: email.inserted_at,
      updatedAt: email.updated_at
    }
end
