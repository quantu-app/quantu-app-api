defmodule Quantu.App.Web.Schema.Journel do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Journel",
      description: "journel show",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        name: %Schema{type: :string, description: "Journel name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journel content"
        },
        language: %Schema{type: :string, description: "Journel language"},
        wordCount: %Schema{type: :integer, description: "Journel word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journel tags"},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [
        :id,
        :userId,
        :name,
        :content,
        :language,
        :wordCount,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => "1234",
        "userId" => "123",
        "name" => "My Journel Entry",
        "content" => [%{insert: "Hello, world!"}],
        "language" => "en",
        "wordCount" => 2,
        "tags" => ["journel", "me"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournelList",
      description: "journel list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => "1234",
          "userId" => "123",
          "name" => "My Journel Entry",
          "content" => [%{insert: "Hello, world!"}],
          "language" => "en",
          "wordCount" => 2,
          "tags" => ["journel", "me"],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournelCreate",
      description: "journel create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Journel name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journel content"
        },
        language: %Schema{type: :string, description: "Journel language"},
        wordCount: %Schema{type: :integer, description: "Journel word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journel tags"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Journel Entry",
        "content" => [%{insert: "Hello, world!"}],
        "language" => "en",
        "wordCount" => 2,
        "tags" => ["journel", "me"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournelUpdate",
      description: "journel update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Journel name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journel content"
        },
        language: %Schema{type: :string, description: "Journel language"},
        wordCount: %Schema{type: :integer, description: "Journel word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journel tags"}
      },
      required: [],
      example: %{
        "name" => "Another Journel",
        "content" => [%{insert: "Hello, world!"}],
        "language" => "en",
        "wordCount" => 1201,
        "tags" => ["journel", "me"]
      }
    })
  end
end
