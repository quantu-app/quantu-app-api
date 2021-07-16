defmodule Quantu.App.Web.Schema.SignUp do
  alias OpenApiSpex.Schema

  defmodule UsernamePassword do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SignUp.UsernamePassword",
      description: "user sign up with username and password",
      type: :object,
      properties: %{
        username: %Schema{type: :string, description: "Username"},
        password: %Schema{type: :string, description: "Password"},
        passwordConfirmation: %Schema{type: :string, description: "Password confirmation"}
      },
      required: [:username, :password, :passwordConfirmation],
      example: %{
        "username" => "username",
        "password" => "password",
        "passwordConfirmation" => "password"
      }
    })
  end
end
