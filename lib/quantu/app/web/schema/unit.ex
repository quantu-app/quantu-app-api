defmodule Quantu.App.Web.Schema.Unit do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Unit",
      description: "unit show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        courseId: %Schema{type: :integer, nullable: true, description: "Unit Course Id"},
        index: %Schema{type: :integer, nullable: true, description: "Unit index in unit"},
        published: %Schema{type: :boolean, nullable: true, description: "Unit published status"},
        name: %Schema{type: :string, description: "Unit name"},
        description: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "Unit description"
        },
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Unit tags"},
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
        "name" => "My Unit",
        "description" => [%{"insert" => "My Unit Description"}],
        "tags" => ["math"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UnitList",
      description: "unit list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => 1001,
          "published" => true,
          "name" => "My Unit",
          "description" => [%{"insert" => "My Unit Description"}],
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
      title: "UnitCreate",
      description: "unit create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Unit name"},
        description: %Schema{
          type: :array,
          items: %Schema{type: :object},
          nullable: true,
          description: "Unit description"
        },
        published: %Schema{type: :boolean, nullable: true, description: "Unit published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Unit tags"
        },
        courseId: %Schema{type: :integer, nullable: true, description: "Unit Course Id"},
        index: %Schema{type: :integer, nullable: true, description: "Unit index in unit"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Unit",
        "published" => true,
        "description" => [%{"insert" => "My Unit Description"}],
        "tags" => ["math"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UnitUpdate",
      description: "unit update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, nullable: true, description: "Unit name"},
        description: %Schema{
          type: :array,
          items: %Schema{type: :object},
          nullable: true,
          description: "Unit description"
        },
        published: %Schema{type: :boolean, nullable: true, description: "Unit published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Unit tags"
        },
        courseId: %Schema{type: :integer, nullable: true, description: "Unit Course Id"},
        index: %Schema{type: :integer, nullable: true, description: "Unit index in unit"}
      },
      required: [],
      example: %{
        "name" => "My Unit Update",
        "published" => true,
        "description" => [%{"insert" => "My Unit Description Updated"}],
        "tags" => ["math", "new-math"]
      }
    })
  end

  defmodule ChildList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UnitChildList",
      description: "unit child list",
      type: :array,
      items: %Schema{
        type: :object,
        oneOf: [Quantu.App.Web.Schema.Quiz.Show, Quantu.App.Web.Schema.Lesson.Show]
      },
      example: [
        %{
          "id" => 1234,
          "organizationId" => 1001,
          "unitId" => 1002,
          "published" => true,
          "name" => "My Quiz",
          "description" => "My Quiz Description",
          "tags" => ["math"],
          "index" => 0,
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        },
        %{
          "id" => 1235,
          "organizationId" => 1001,
          "unitId" => 1002,
          "published" => true,
          "name" => "My Lesson",
          "description" => "My Lesson Description",
          "tags" => ["math"],
          "content" => [%{"insert" => "Hello, world!"}],
          "index" => 1,
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end
end
