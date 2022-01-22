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

  defmodule Public do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UserPublic",
      description: "A public user",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        username: %Schema{type: :string, description: "User name"},
        active: %Schema{type: :boolean, description: "User active status"},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      additionalProperties: false,
      required: [:id, :username, :insertedAt, :updatedAt],
      example: %{
        "id" => "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02",
        "username" => "example",
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Private do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UserPrivate",
      description: "A private user",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        token: %Schema{type: :string, description: "User Token"},
        username: %Schema{type: :string, description: "User name"},
        active: %Schema{type: :boolean, description: "User active status"},
        creator: %Schema{type: :boolean, nullable: true, description: "User creator status"},
        email: Email,
        emails: %Schema{type: :array, items: Email},
        firstName: %Schema{type: :string, nullable: true, description: "User first name"},
        lastName: %Schema{type: :string, nullable: true, description: "User last name"},
        birthday: %Schema{type: :string, nullable: true, description: "User birthday"},
        country: %Schema{type: :string, nullable: true, description: "User country"},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      additionalProperties: false,
      required: [
        :id,
        :token,
        :username,
        :active,
        :creator,
        :emails,
        :firstName,
        :lastName,
        :birthday,
        :country,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => "ebf5b33a-7a68-41b7-8d0b-9b3a32caff02",
        "token" => "DwBg/rBlmXjTnQ3Xw9Hhr0A5hY1+FNHk1GlWnGPhbfX1ctqyqdlbiDXMX2Nzbxfu",
        "username" => "example",
        "active" => true,
        "creator" => true,
        "firstName" => "John",
        "lastName" => "Doe",
        "birthday" => "1990-01-01",
        "country" => "US",
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

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UserUpdate",
      description: "A private user update",
      type: :object,
      properties: %{
        username: %Schema{type: :string, nullable: true, description: "User name"},
        active: %Schema{type: :boolean, nullable: true, description: "User active status"},
        firstName: %Schema{type: :string, nullable: true, description: "User first name"},
        lastName: %Schema{type: :string, nullable: true, description: "User last name"},
        birthday: %Schema{type: :string, nullable: true, description: "User birthday"},
        country: %Schema{type: :string, nullable: true, description: "User country"}
      },
      additionalProperties: false,
      required: [],
      example: %{
        "username" => "new_example",
        "active" => true,
        "firstName" => "John",
        "lastName" => "Doe",
        "birthday" => "1990-01-01",
        "country" => "US"
      }
    })
  end
end
