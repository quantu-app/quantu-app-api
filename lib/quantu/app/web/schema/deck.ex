defmodule Quantu.App.Web.Schema.Deck do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Deck",
      description: "deck show",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        name: %Schema{type: :string, description: "Deck name"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Deck tags"},
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
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => "1234",
        "userId" => "123",
        "name" => "My Deck Entry",
        "tags" => ["deck", "me"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DeckList",
      description: "deck list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => "1234",
          "userId" => "123",
          "name" => "My Deck Entry",
          "tags" => ["deck", "me"],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DeckCreate",
      description: "deck create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Deck name"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Deck tags"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Deck Entry",
        "tags" => ["deck", "me"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DeckUpdate",
      description: "deck update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Deck name"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Deck tags"}
      },
      required: [],
      example: %{
        "name" => "Another Deck",
        "tags" => ["deck", "me"]
      }
    })
  end
end
