defmodule Quantu.App.Web.Schema.Question do
  alias OpenApiSpex.Schema

  defmodule FlashCard do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionFlashCard",
      description: "Question flash card prompt",
      type: :object,
      properties: %{
        front: %Schema{type: :array, items: %Schema{type: :object}, description: "front content"},
        back: %Schema{type: :array, items: %Schema{type: :object}, description: "back content"}
      },
      required: [
        :front,
        :back
      ],
      example: %{
        "front" => [%{"insert" => "Front"}],
        "back" => [%{"insert" => "Back"}]
      }
    })
  end

  defmodule MultipleChoice do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionMultipleChoice",
      description: "Question multiple choice prompt",
      type: :object,
      properties: %{
        question: %Schema{type: :array, items: %Schema{type: :object}, description: "question content"},
        choices: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              key: %Schema{type: :string, description: "choice key"},
              content: %Schema{type: :array, items: %Schema{type: :object}, description: "choice content"},
              correct: %Schema{type: :boolean, description: "is this choice correct?"}
            },
            required: [
              :key,
              :content
            ]
          },
          description: "answer choices"
        }
      },
      required: [
        :question,
        :choices
      ],
      example: %{
        "question" => [%{"insert" => "Which is the lowest Number?"}],
        "choices" => [
          %{
            "key" => "1",
            "content" => [%{"insert" => "0"}],
            "correct" => true
          },
          %{
            "key" => "2",
            "content" => [%{"insert" => "1"}],
            "correct" => false
          },
        ]
      }
    })
  end

  defmodule Prompt do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionPrompt",
      description: "Question prompt",
      type: :object,
      oneOf: [MultipleChoice, FlashCard],
      example: %{
        "front" => [%{"insert" => "Front"}],
        "back" => [%{"insert" => "Back"}]
      }
    })
  end

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Question",
      description: "question show",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        quizId: %Schema{type: :integer, nullable: true, description: "Quiz Id"},
        type: %Schema{type: :string, description: "Question type"},
        prompt: Prompt,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
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
        :type,
        :prompt,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "type" => "flash_card",
        "prompt" => %{
          "front" => [%{"insert" => "Front"}],
          "back" => [%{"insert" => "Back"}]
        },
        "tags" => ["math"],
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionList",
      description: "question list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1234,
          "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
          "type" => "flash_card",
          "prompt" => %{
            "front" => [%{"insert" => "Front"}],
            "back" => [%{"insert" => "Back"}]
          },
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
      title: "QuestionCreate",
      description: "question create",
      type: :object,
      properties: %{
        quizId: %Schema{type: :integer, description: "Quiz Id"},
        type: %Schema{type: :string, description: "Question type"},
        prompt: Prompt,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        index: %Schema{type: :integer, description: "Quiz Index"},
      },
      required: [
        :type,
        :prompt,
        :tags
      ],
      example: %{
        "type" => "flash_card",
        "prompt" => %{
          "front" => [%{"insert" => "Front"}],
          "back" => [%{"insert" => "Back"}]
        },
        "tags" => ["math"],
      }
    })
  end

  defmodule Update do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionUpdate",
      description: "question update",
      type: :object,
      properties: %{
        quizId: %Schema{type: :integer, description: "Quiz Id"},
        type: %Schema{type: :string, description: "Question type"},
        prompt: Prompt,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        index: %Schema{type: :integer, description: "Quiz Index"},
      },
      required: [],
      example: %{
        "type" => "multiple_choice",
        "prompt" => %{
          "question" => [%{"insert" => "Which is the lowest Number?"}],
          "choices" => [
            %{
              "key" => "1",
              "content" => [%{"insert" => "0"}],
              "correct" => true
            },
            %{
              "key" => "2",
              "content" => [%{"insert" => "1"}],
              "correct" => false
            },
          ]
        },
        "tags" => ["math", "new-math"],
      }
    })
  end
end
