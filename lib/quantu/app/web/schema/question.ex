defmodule Quantu.App.Web.Schema.Question do
  alias OpenApiSpex.Schema

  defmodule FlashCardPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionFlashCardPrivate",
      description: "Question flash card private prompt",
      type: :object,
      properties: %{
        front: %Schema{type: :array, items: %Schema{type: :object}, description: "front content"},
        back: %Schema{type: :array, items: %Schema{type: :object}, description: "back content"}
      },
      additionalProperties: false,
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
      additionalProperties: false,
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

  defmodule MultipleChoicePrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionMultipleChoicePrivate",
      description: "Question multiple choice private prompt",
      type: :object,
      properties: %{
        question: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "question content"
        },
        explanation: %Schema{
          type: :array,
          items: %Schema{type: :object},
          nullable: true,
          description: "question explanation"
        },
        choices: %Schema{
          type: :object,
          properties: %{
            ".*": %Schema{
              type: :object,
              properties: %{
                content: %Schema{
                  type: :array,
                  items: %Schema{type: :object},
                  description: "choice content"
                },
                correct: %Schema{type: :boolean, description: "is this choice correct?"}
              },
              additionalProperties: false,
              required: [
                :key,
                :content
              ]
            }
          },
          description: "answer choices"
        }
      },
      additionalProperties: false,
      required: [
        :question,
        :choices
      ],
      example: %{
        "question" => [%{"insert" => "Which is the lowest Number?"}],
        "explanation" => [%{"insert" => "Zero is."}],
        "choices" => %{
          "a" => %{
            "correct" => true,
            "content" => [%{"insert" => "0"}]
          },
          "b" => %{
            "correct" => false,
            "content" => [%{"insert" => "1"}]
          }
        }
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
        question: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "question content"
        },
        choices: %Schema{
          type: :object,
          properties: %{
            ".*": %Schema{
              type: :object,
              properties: %{
                content: %Schema{
                  type: :array,
                  items: %Schema{type: :object},
                  description: "choice content"
                }
              },
              additionalProperties: false,
              required: [
                :key,
                :content
              ]
            }
          },
          description: "answer choices"
        }
      },
      additionalProperties: false,
      required: [
        :question,
        :choices
      ],
      example: %{
        "question" => [%{"insert" => "Which is the lowest Number?"}],
        "choices" => %{
          "a" => %{
            "content" => [%{"insert" => "0"}]
          },
          "b" => %{
            "content" => [%{"insert" => "1"}]
          }
        }
      }
    })
  end

  defmodule PromptPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionPromptPrivate",
      description: "Question prompt private",
      type: :object,
      oneOf: [MultipleChoicePrivate, FlashCardPrivate],
      example: %{
        "front" => [%{"insert" => "Front"}],
        "back" => [%{"insert" => "Back"}]
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

  defmodule ShowPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionPrivate",
      description: "question show private",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        organizationId: %Schema{type: :integer, description: "Organization Id"},
        quizId: %Schema{type: :integer, nullable: true, description: "Quiz Id"},
        index: %Schema{type: :integer, nullable: true, description: "Question index in quiz"},
        name: %Schema{type: :string, nullable: true, description: "Question name"},
        type: %Schema{
          type: :string,
          enum: ["flash_card", "multiple_choice"],
          description: "Question type"
        },
        prompt: PromptPrivate,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
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
        :name,
        :type,
        :prompt,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "name" => "Question",
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
        index: %Schema{type: :integer, nullable: true, description: "Question index in quiz"},
        name: %Schema{type: :string, nullable: true, description: "Question name"},
        type: %Schema{
          type: :string,
          enum: ["flash_card", "multiple_choice"],
          description: "Question type"
        },
        prompt: Prompt,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
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
        :name,
        :type,
        :prompt,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
        "name" => "Question",
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

  defmodule ListPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionListPrivate",
      description: "question list private",
      type: :array,
      items: ShowPrivate,
      example: [
        %{
          "id" => 1234,
          "organizationId" => "6b934301-847a-4ce9-85fb-82e8eb7c9ab6",
          "name" => "Question",
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
          "name" => "Question",
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
        quizId: %Schema{type: :integer, nullable: true, description: "Quiz Id"},
        name: %Schema{type: :string, nullable: true, description: "Question name"},
        type: %Schema{
          type: :string,
          enum: ["flash_card", "multiple_choice"],
          description: "Question type"
        },
        prompt: PromptPrivate,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        index: %Schema{type: :integer, nullable: true, description: "Quiz Index"}
      },
      required: [
        :type,
        :prompt,
        :tags
      ],
      example: %{
        "name" => "Question",
        "type" => "flash_card",
        "prompt" => %{
          "front" => [%{"insert" => "Front"}],
          "back" => [%{"insert" => "Back"}]
        },
        "tags" => ["math"]
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
        quizId: %Schema{type: :integer, nullable: true, description: "Quiz Id"},
        name: %Schema{type: :string, nullable: true, description: "Question name"},
        type: %Schema{type: :string, nullable: true, description: "Question type"},
        prompt: PromptPrivate,
        tags: %Schema{
          type: :array,
          items: %Schema{type: :string},
          nullable: true,
          description: "Question tags"
        },
        index: %Schema{type: :integer, nullable: true, description: "Quiz Index"}
      },
      required: [],
      example: %{
        "name" => "Question",
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
        "tags" => ["math", "new-math"]
      }
    })
  end

  defmodule MultipleChoiceAnswer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "MultipleChoiceAnswer",
      description: "Multiple choice answer",
      anyOf: [
        %Schema{
          type: :array,
          items: %Schema{type: :string}
        },
        %Schema{type: :string}
      ],
      example: "a"
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
          anyOf: [FlashCardAnswer, MultipleChoiceAnswer],
          description: "Question Answer input"
        }
      },
      example: %{
        "input" => "a"
      }
    })
  end

  defmodule Result do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionResult",
      description: "Question result",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        questionId: %Schema{type: :integer, description: "Question Id"},
        type: %Schema{
          type: :string,
          enum: ["flash_card", "multiple_choice"],
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
      example: %{
        "id" => 1,
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
          "input" => "a"
        },
        "insertedAt" => "2017-09-12T12:34:55Z",
        "updatedAt" => "2017-09-13T10:11:12Z"
      }
    })
  end
end
