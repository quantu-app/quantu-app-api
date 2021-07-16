defmodule Quantu.App.Web.Schema.SignIn do
  alias OpenApiSpex.Schema

  defmodule UsernameOrEmailAndPassword do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SignInUsernameOrEmailAndPassword",
      description: "user sign in with username or email and password",
      type: :object,
      properties: %{
        usernameOrEmail: %Schema{type: :string, description: "Email or Username"},
        password: %Schema{type: :string, description: "Password"}
      },
      required: [:password, :usernameOrEmail],
      example: %{
        "usernameOrEmail" => "example@domain.com",
        "password" => "password"
      }
    })
  end
end
