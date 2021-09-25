defmodule Quantu.App.Web.View.User do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.{User, Email}

  def render("index.json", %{users: users}) do
    render_many(users, User, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, User, "user.json")
  end

  def render("private_show.json", %{user: user, token: token}) do
    render_one(user, User, "private_user.json", %{token: token})
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      insertedAt: user.inserted_at,
      updatedAt: user.updated_at
    }
  end

  def render("private_user.json", %{user: user, token: token}) do
    %{
      id: user.id,
      token: token,
      username: user.username,
      creator: user.creator,
      email: render_email(user.emails),
      emails:
        render_many(
          Enum.filter(user.emails, fn email -> not email.primary end),
          Email,
          "email.json"
        ),
      insertedAt: user.inserted_at,
      updatedAt: user.updated_at
    }
  end

  defp render_email(emails) do
    case primary_email(emails) do
      nil ->
        nil

      email ->
        render_one(email, Email, "email.json")
    end
  end

  defp primary_email(emails) do
    case emails
         |> Enum.filter(fn email -> email.confirmed and email.primary end)
         |> Enum.at(0) do
      nil ->
        nil

      email ->
        email
    end
  end
end
