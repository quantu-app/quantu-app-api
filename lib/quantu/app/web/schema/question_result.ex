defmodule Quantu.App.Web.Schema.QuestionResult do
  alias OpenApiSpex.Schema
  alias Quantu.App.Web.Schema.Question.PromptPrivate

  defmodule InputAnswer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "InputAnswer",
      description: "Input answer",
      type: :string,
      example: "a"
    })
  end

  defmodule MarkAsReadAnswer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "MarkAsReadAnswer",
      description: "Mark as read answer",
      type: :boolean,
      example: true
    })
  end

  defmodule MultipleChoiceAnswer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "MultipleChoiceAnswer",
      description: "Multiple choice answer",
      type: :array,
      items: %Schema{type: :string},
      example: ["a"]
    })
  end

  defmodule FlashCardAnswer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "FlashCardAnswer",
      description: "Flash card answer",
      type: :number,
      example: 1
    })
  end

  defmodule Answer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionAnswer",
      description: "Question answer",
      type: :object,
      properties: %{
        input: %Schema{
          anyOf: [FlashCardAnswer, MultipleChoiceAnswer, InputAnswer, MarkAsReadAnswer],
          description: "Question Answer input"
        }
      },
      example: %{
        "input" => ["a"]
      }
    })
  end

  defmodule Show do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionResult",
      description: "Question result",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        userId: %Schema{type: :string, description: "Question results user Id"},
        questionId: %Schema{type: :integer, description: "Question results Id"},
        type: %Schema{
          type: :string,
          enum: ["flash_card", "multiple_choice", "input", "mark_as_read"],
          description: "Question type"
        },
        prompt: PromptPrivate,
        answer: Answer,
        result: %Schema{
          type: :number,
          description: "Question Answer result"
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
        :userId,
        :questionId,
        :type,
        :prompt,
        :result,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1,
        "userId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "questionId" => 1,
        "result" => 1.0,
        "type" => "multiple_choice",
        "prompt" => %{
          "question" => [%{"insert" => "Which is the lowest Number?"}],
          "explanation" => [%{"insert" => "Zero is."}],
          "choices" => %{
            "a" => %{
              "content" => [%{"insert" => "0"}],
              "correct" => true
            },
            "b" => %{
              "content" => [%{"insert" => "1"}],
              "correct" => false
            }
          }
        },
        "answer" => %{
          "input" => ["a"]
        },
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule List do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionResultList",
      description: "question result list",
      type: :array,
      items: Show,
      example: [
        %{
          "id" => 1,
          "userId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
          "questionId" => 1,
          "result" => 1.0,
          "type" => "multiple_choice",
          "prompt" => %{
            "question" => [%{"insert" => "Which is the lowest Number?"}],
            "explanation" => [%{"insert" => "Zero is."}],
            "choices" => %{
              "a" => %{
                "content" => [%{"insert" => "0"}],
                "correct" => true
              },
              "b" => %{
                "content" => [%{"insert" => "1"}],
                "correct" => false
              }
            }
          },
          "answer" => %{
            "input" => ["a"]
          },
          "insertedAt" => "2017-09-12T12:34:55Z",
          "updatedAt" => "2017-09-13T10:11:12Z"
        }
      ]
    })
  end
end
