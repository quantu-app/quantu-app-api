defmodule Quantu.App.Web.View.Organization do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.Organization

  def render("index.json", %{organizations: organizations}),
    do: render_many(organizations, Organization, "organization.json")

  def render("show.json", %{organization: organization}),
    do: render_one(organization, Organization, "organization.json")

  def render("organization.json", %{organization: organization}),
    do: %{
      id: organization.id,
      userId: organization.user_id,
      name: organization.name,
      url: organization.url,
      tags: organization.tags,
      insertedAt: organization.inserted_at,
      updatedAt: organization.updated_at
    }
end
