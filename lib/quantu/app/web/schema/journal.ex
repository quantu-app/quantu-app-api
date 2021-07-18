defmodule Quantu.App.Web.Schema.Journal do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Journal",
      description: "journal show",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        name: %Schema{type: :string, description: "Journal name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journal content"
        },
        location: %Schema{type: :string, description: "Journal location"},
        language: %Schema{type: :string, description: "Journal language"},
        wordCount: %Schema{type: :integer, description: "Journal word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journal tags"},
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
        :location,
        :language,
        :wordCount,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => "1234",
        "userId" => "123",
        "name" => "My Journal Entry",
        "content" => [%{insert: "Hello, world!"}],
        "location" => "Somewhere in the Americas",
        "language" => "en",
        "wordCount" => 2,
        "tags" => ["journal", "me"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournalList",
      description: "journal list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => "1234",
          "userId" => "123",
          "name" => "My Journal Entry",
          "content" => [%{insert: "Hello, world!"}],
          "location" => "Somewhere in the Americas",
          "language" => "en",
          "wordCount" => 2,
          "tags" => ["journal", "me"],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournalCreate",
      description: "journal create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Journal name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journal content"
        },
        location: %Schema{type: :string, description: "Journal location"},
        language: %Schema{type: :string, description: "Journal language"},
        wordCount: %Schema{type: :integer, description: "Journal word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journal tags"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Journal Entry",
        "content" => [%{insert: "Hello, world!"}],
        "location" => "Somewhere in the Americas",
        "language" => "en",
        "wordCount" => 2,
        "tags" => ["journal", "me"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "JournalUpdate",
      description: "journal update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Journal name"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Journal content"
        },
        location: %Schema{type: :string, description: "Journal location"},
        language: %Schema{type: :string, description: "Journal language"},
        wordCount: %Schema{type: :integer, description: "Journal word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Journal tags"}
      },
      required: [],
      example: %{
        "name" => "Another Journal",
        "content" => [%{insert: "Hello, world!"}],
        "location" => "Somewhere in the Americas",
        "language" => "en",
        "wordCount" => 1201,
        "tags" => ["journal", "me"]
      }
    })
  end
end
