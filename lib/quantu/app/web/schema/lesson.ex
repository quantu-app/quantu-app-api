defmodule Quantu.App.Web.Schema.Lesson do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Lesson",
      description: "lesson show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Lesson index in unit"},
        type: %Schema{type: :string, enum: ["lesson"], nullable: true, description: "Lesson type"},
        published: %Schema{type: :boolean, nullable: true, description: "Lesson published status"},
        name: %Schema{type: :string, description: "Lesson name"},
        description: %Schema{type: :string, description: "Lesson description"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Lesson tags"},
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Lesson content"
        },
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
        :content,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => 1001,
        "published" => true,
        "name" => "My Lesson",
        "description" => "My Lesson Description",
        "tags" => ["math"],
        "content" => [%{"insert" => "Hello, world!"}],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "LessonList",
      description: "lesson list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => 1001,
          "published" => true,
          "name" => "My Lesson",
          "description" => "My Lesson Description",
          "tags" => ["math"],
          "content" => [%{"insert" => "Hello, world!"}],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "LessonCreate",
      description: "lesson create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Lesson name"},
        description: %Schema{type: :string, nullable: true, description: "Lesson description"},
        published: %Schema{type: :boolean, nullable: true, description: "Lesson published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Lesson tags"
        },
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Lesson content"
        },
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Lesson index in unit"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Lesson",
        "published" => true,
        "description" => "My Lesson Description",
        "tags" => ["math"],
        "content" => [%{"insert" => "Hello, world!"}]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "LessonUpdate",
      description: "lesson update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, nullable: true, description: "Lesson name"},
        description: %Schema{type: :string, nullable: true, description: "Lesson description"},
        published: %Schema{type: :boolean, nullable: true, description: "Lesson published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Lesson tags"
        },
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Lesson content"
        },
        unitId: %Schema{type: :integer, nullable: true, description: "Unit Id"},
        index: %Schema{type: :integer, nullable: true, description: "Lesson index in unit"}
      },
      required: [],
      example: %{
        "name" => "My Lesson Update",
        "published" => true,
        "description" => "My Lesson Description Updated",
        "tags" => ["math", "new-math"],
        "content" => [%{"insert" => "Hello, new world!"}]
      }
    })
  end
end
