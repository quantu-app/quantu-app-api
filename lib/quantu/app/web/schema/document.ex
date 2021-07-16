defmodule Quantu.App.Web.Schema.Document do
  alias OpenApiSpex.Schema

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Document.Show",
      description: "document show",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        userId: %Schema{type: :string, description: "User Id"},
        name: %Schema{type: :string, description: "Document name"},
        type: %Schema{type: :string, description: "Document type"},
        url: %Schema{type: :string, description: "Document url"},
        contentHash: %Schema{type: :string, description: "Document content hash"},
        language: %Schema{type: :string, description: "Document langauge"},
        wordCount: %Schema{type: :integer, description: "Document word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Document tags"},
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
        :type,
        :url,
        :contentHash,
        :language,
        :wordCount,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => "1234",
        "userId" => "123",
        "name" => "My Journel Entry",
        "type" => "journel",
        "url" => "https://somelocation.com/path/to/file.document",
        "contentHash" => "sha256:asdf34gfg",
        "langauge" => "en",
        "wordCount" => 101,
        "tags" => ["journel", "me"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Document.List",
      description: "document list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => "1234",
          "userId" => "123",
          "name" => "My Journel Entry",
          "type" => "journel",
          "url" => "https://somelocation.com/path/to/file.document",
          "contentHash" => "sha256:asdf34gfg",
          "langauge" => "en",
          "wordCount" => 101,
          "tags" => ["journel", "me"],
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end

  defmodule Create do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Document.Create",
      description: "document create",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Document name"},
        type: %Schema{type: :string, description: "Document type"},
        language: %Schema{type: :string, description: "Document langauge"},
        wordCount: %Schema{type: :integer, description: "Document word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Document tags"}
      },
      required: [
        :name,
        :type,
        :language,
        :wordCount,
        :tags
      ],
      example: %{
        "name" => "My Journel Entry",
        "type" => "journel",
        "langauge" => "en",
        "wordCount" => 101,
        "tags" => ["journel", "me"]
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Document.Update",
      description: "document update",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Document name"},
        type: %Schema{type: :string, description: "Document type"},
        language: %Schema{type: :string, description: "Document langauge"},
        wordCount: %Schema{type: :integer, description: "Document word count"},
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Document tags"}
      },
      required: [],
      example: %{
        "name" => "Another Journel",
        "type" => "journel",
        "langauge" => "en",
        "wordCount" => 101,
        "tags" => ["journel", "me"]
      }
    })
  end

  defmodule Upload do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Document.Update",
      description: "document update",
      type: :object,
      properties: %{
        url: %Schema{type: :string, format: :binary, description: "Document url"},
        contentHash: %Schema{type: :string, description: "Document content hash"}
      },
      required: [:url, :contentHash],
      example: %{
        "url" => "https://somelocation.com/path/to/file.document",
        "contentHash" => "sha256:asdf34gfg"
      }
    })
  end
end
