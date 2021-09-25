defmodule Quantu.App.Web.Schema.User do
  alias OpenApiSpex.Schema

  defmodule Email do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Email",
      description: "user email",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        email: %Schema{type: :string, description: "Email address", format: :email},
        confirmed: %Schema{type: :boolean, description: "Email confirmation status"},
        primary: %Schema{type: :boolean, description: "Email primary status"},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      nullable: true,
      additionalProperties: false,
      required: [:id, :userId, :email, :confirmed, :primary, :insertedAt, :updatedAt],
      example: %{
        "id" => 1234,
        "userId" => "3245asfgws34tersf34t5",
        "email" => "example@domain.com",
        "confirmed" => true,
        "primary" => true,
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule EmailCreate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "EmailCreate",
      description: "create user email",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email address", format: :email}
      },
      additionalProperties: false,
      required: [:email],
      example: %{
        "email" => "example@domain.com"
      }
    })
  end

  defmodule PasswordReset do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "PasswordReset",
      description: "create user email",
      type: :object,
      properties: %{
        oldPassword: %Schema{type: :string, description: "old password"},
        password: %Schema{type: :string, description: "password"}
      },
      additionalProperties: false,
      required: [:oldPassword, :password],
      example: %{
        "oldPassword" => "oldPassword",
        "password" => "password"
      }
    })
  end

  defmodule UsernameUpdate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UsernameUpdate",
      description: "update user's username",
      type: :object,
      properties: %{
        username: %Schema{type: :string, description: "username"}
      },
      additionalProperties: false,
      required: [:username],
      example: %{
        "username" => "new_username"
      }
    })
  end

  defmodule Private do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User",
      description: "A private user",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        token: %Schema{type: :string, description: "User Token"},
        username: %Schema{type: :string, description: "User name"},
        creator: %Schema{type: :boolean, nullable: true, description: "User creator status"},
        email: Email,
        emails: %Schema{type: :array, items: Email},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      additionalProperties: false,
      required: [:id, :token, :username, :emails, :insertedAt, :updatedAt],
      example: %{
        "id" => "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02",
        "token" => "DwBg/rBlmXjTnQ3Xw9Hhr0A5hY1+FNHk1GlWnGPhbfX1ctqyqdlbiDXMX2Nzbxfu",
        "username" => "example",
        "creator" => true,
        "email" => %{
          "id" => 1234,
          "userId" => "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02",
          "email" => "example@domain.com",
          "confirmed" => true,
          "primary" => true,
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        },
        "emails" => [],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end
end
