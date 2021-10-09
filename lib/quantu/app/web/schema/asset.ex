defmodule Quantu.App.Web.Schema.Asset do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Asset",
      description: "asset show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        parentId: %Schema{type: :integer, nullable: true, description: "Asset parent id"},
        name: %Schema{type: :string, description: "Asset name"},
        url: %Schema{type: :string, format: :url, description: "Asset url"},
        type: %Schema{type: :string, description: "Asset type"},
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
        :parentId,
        :name,
        :url,
        :type,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => 1001,
        "parentId" => nil,
        "name" => "image.png",
        "url" => "static/assets/1001/1234",
        "type" => "image/png",
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AssetList",
      description: "asset list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => 1001,
          "name" => "image.png",
          "url" => "static/assets/1001/1234",
          "type" => "image/png",
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule File do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AssetFile",
      description: "asset show file",
      type: :file
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AssetCreate",
      description: "asset create",
      type: :object,
      properties: %{
        parentId: %Schema{type: :integer, nullable: true, description: "Asset parent id"},
        name: %Schema{type: :string, format: :binary, description: "Asset file name"},
        type: %Schema{type: :string, nullable: true, description: "Asset type"}
      },
      required: [
        :name
      ],
      example: %{
        "parentId" => nil,
        "name" => "image.png"
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AssetUpdate",
      description: "asset update",
      type: :object,
      properties: %{
        parentId: %Schema{type: :integer, nullable: true, description: "Asset parent id"},
        name: %Schema{type: :string, format: :binary, description: "Asset file name"}
      },
      required: [],
      example: %{
        "parentId" => nil,
        "name" => "new_image.png"
      }
    })
  end
end
