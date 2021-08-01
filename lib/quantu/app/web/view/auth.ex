defmodule Quantu.App.Web.View.Auth do
  use Quantu.App.Web, :view

  alias Quantu.App.Web.View.User

  def user_json(user, token),
    do: render_one(user, User, "private_user.json", %{token: token})
end
