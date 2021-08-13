defmodule Quantu.App.Web.Schema.Organization do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Organization",
      description: "organization show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        name: %Schema{type: :string, description: "Organization name"},
        url: %Schema{type: :string, description: "Organization url"},
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
        :userId,
        :name,
        :url,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "userId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "name" => "My Organization",
        "url" => "my-organization-entry",
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "OrganizationList",
      description: "organization list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => "1234",
          "userId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
          "name" => "My Organization",
          "url" => "my-organization-entry",
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "OrganizationCreate",
      description: "organization create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Organization name"},
        url: %Schema{type: :string, description: "Organization url"}
      },
      required: [
        :name
      ],
      example: %{
        "name" => "My Organization",
        "url" => "my-organization-entry"
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "OrganizationUpdate",
      description: "organization update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Organization name"},
        url: %Schema{type: :string, description: "Organization url"}
      },
      required: [],
      example: %{
        "name" => "Another Organization",
        "url" => "my-organization-entry"
      }
    })
  end
end
