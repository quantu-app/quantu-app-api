defmodule Quantu.App.Web.Schema.Quiz do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Quiz",
      description: "quiz show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        name: %Schema{type: :string, description: "Quiz name"},
        description: %Schema{type: :string, description: "Quiz description"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Quiz tags"},
        insertedAt: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [
        :id,
        :organizationId,
        :name,
        :description,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "name" => "My Quiz",
        "description" => "My Quiz Description",
        "tags" => ["math"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuizList",
      description: "quiz list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
          "name" => "My Quiz",
          "description" => "My Quiz Description",
          "tags" => ["math"],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuizCreate",
      description: "quiz create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Quiz name"},
        description: %Schema{type: :string, nullable: true, description: "Quiz description"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, nullable: true, description: "Quiz tags"},
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Quiz",
        "description" => "My Quiz Description",
        "tags" => ["math"],
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuizUpdate",
      description: "quiz update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, nullable: true, description: "Quiz name"},
        description: %Schema{type: :string, nullable: true, description: "Quiz description"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, nullable: true, description: "Quiz tags"},
      },
      required: [],
      example: %{
        "name" => "My Quiz Update",
        "description" => "My Quiz Description Updated",
        "tags" => ["math", "new-math"],
      }
    })
  end
end
