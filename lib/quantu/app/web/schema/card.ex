defmodule Quantu.App.Web.Schema.Card do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Card",
      description: "card show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        deckId: %Schema{type: :string, description: "Deck Id"},
        front: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card front"
        },
        back: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card front"
        },
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [
        :id,
        :deckId,
        :front,
        :back,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "deckId" => "123",
        "front" => [%{insert: "Hello"}],
        "back" => [%{insert: "world!"}],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CardList",
      description: "card list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "deckId" => "123",
          "front" => [%{insert: "Hello"}],
          "back" => [%{insert: "world!"}],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CardCreate",
      description: "card create",
      type: :object,
      properties: %{
        front: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card front"
        },
        back: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card back"
        }
      },
      required: [
        :front,
        :back
      ],
      example: %{
        "front" => [%{insert: "Hello"}],
        "back" => [%{insert: "world!"}]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CardUpdate",
      description: "card update",
      type: :object,
      properties: %{
        front: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card front"
        },
        back: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Card back"
        }
      },
      required: [],
      example: %{
        "front" => [%{insert: "Hello"}],
        "back" => [%{insert: "world!"}]
      }
    })
  end
end
