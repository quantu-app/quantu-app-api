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
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Quiz index in unit"},
        published: %Schema{type: :boolean, nullable: true, description: "Quiz published status"},
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
      additionalProperties: false,
      required: [
        :id,
        :organizationId,
        :published,
        :name,
        :description,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => 1001,
        "published" => true,
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
          "organizationId" => 1001,
          "published" => true,
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
        published: %Schema{type: :boolean, nullable: true, description: "Quiz published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Quiz tags"
        },
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Quiz index in unit"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Quiz",
        "published" => true,
        "description" => "My Quiz Description",
        "tags" => ["math"]
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
        published: %Schema{type: :boolean, nullable: true, description: "Quiz published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Quiz tags"
        },
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Quiz index in unit"}
      },
      required: [],
      example: %{
        "name" => "My Quiz Update",
        "published" => true,
        "description" => "My Quiz Description Updated",
        "tags" => ["math", "new-math"]
      }
    })
  end

  defmodule QuestionIds do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuizQuestionIds",
      description: "quiz questions ids",
      type: :object,
      properties: %{
        questions: %Schema{
          type: :array,
          items: %Schema{
            type: :integer
          },
          nullable: true,
          description: "Question ids"
        }
      },
      required: [],
      example: %{
        "questions" => [1, 2]
      }
    })
  end
end
