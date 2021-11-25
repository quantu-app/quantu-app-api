defmodule Quantu.App.Web.Schema.Course do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Course",
      description: "course show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        published: %Schema{type: :boolean, nullable: true, description: "Course published status"},
        name: %Schema{type: :string, description: "Course name"},
        description: %Schema{type: :string, description: "Course description"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Course tags"},
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
        "name" => "My Course",
        "description" => "My Course Description",
        "tags" => ["math"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CourseList",
      description: "course list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => 1001,
          "published" => true,
          "name" => "My Course",
          "description" => "My Course Description",
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
      title: "CourseCreate",
      description: "course create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Course name"},
        description: %Schema{type: :string, nullable: true, description: "Course description"},
        published: %Schema{type: :boolean, nullable: true, description: "Course published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Course tags"
        }
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Course",
        "published" => true,
        "description" => "My Course Description",
        "tags" => ["math"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CourseUpdate",
      description: "course update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, nullable: true, description: "Course name"},
        description: %Schema{type: :string, nullable: true, description: "Course description"},
        published: %Schema{type: :boolean, nullable: true, description: "Course published status"},
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Course tags"
        }
      },
      required: [],
      example: %{
        "name" => "My Course Update",
        "published" => true,
        "description" => "My Course Description Updated",
        "tags" => ["math", "new-math"]
      }
    })
  end
end
