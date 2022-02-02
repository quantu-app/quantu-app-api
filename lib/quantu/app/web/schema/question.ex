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

  defmodule MarkAsReadPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionMarkAsReadPrivate",
      description: "Question mark as read private content",
      type: :object,
      properties: %{
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "content"
        }
      },
      additionalProperties: false,
      required: [
        :content
      ],
      example: %{
        "content" => [%{"insert" => "Did you read this?"}]
      }
    })
  end

  defmodule MarkAsRead do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionMarkAsRead",
      description: "Question mark as read content",
      type: :object,
      properties: %{
        content: %Schema{
          type: :array,
          items: %Schema{type: :object},
          description: "content"
        }
      },
      additionalProperties: false,
      required: [
        :content
      ],
      example: %{
        "content" => [%{"insert" => "Did you read this?"}]
      }
    })
  end

  defmodule InputPrivate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionInputPrivate",
      description: "Question input private prompt",
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
        type: %Schema{
          type: :string,
          enum: ["number", "latex", "text"],
          description: "question input type"
        },
        answers: %Schema{
          type: :array,
          items: %Schema{oneOf: [%Schema{type: :string}, %Schema{type: :number}]},
          description: "answers"
        }
      },
      additionalProperties: false,
      required: [
        :question,
        :type,
        :answers
      ],
      example: %{
        "question" => [%{"insert" => "Which is lower, 1 or 2"}],
        "explanation" => [%{"insert" => "One is."}],
        "type" => "number",
        "answers" => ["1"]
      }
    })
  end

  defmodule Input do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "QuestionInput",
      description: "Question input prompt",
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
        type: %Schema{
          type: :string,
          enum: ["number", "latex", "text"],
          description: "question input type"
        }
      },
      additionalProperties: false,
      required: [
        :question,
        :type
      ],
      example: %{
        "question" => [%{"insert" => "Which is lower, 1 or 2"}],
        "explanation" => [%{"insert" => "One is."}],
        "type" => "number"
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
        singleAnswer: %Schema{
          type: :boolean,
          nullable: true,
          description: "question singleAnswer"
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
        "singleAnswer" => true,
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
      oneOf: [MultipleChoicePrivate, FlashCardPrivate, InputPrivate, MarkAsReadPrivate],
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
      oneOf: [MultipleChoice, FlashCard, Input, MarkAsRead],
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
          enum: ["flash_card", "multiple_choice", "input", "mark_as_read"],
          description: "Question type"
        },
        prompt: PromptPrivate,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        isChallenge: %Schema{type: :boolean, description: "Is this a challenge question?"},
        releasedAt: %Schema{
          type: :string,
          format: :"date-time",
          description: "When was this question released?"
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
        :name,
        :type,
        :prompt,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => 1001,
        "name" => "Question",
        "type" => "flash_card",
        "prompt" => %{
          "front" => [%{"insert" => "Front"}],
          "back" => [%{"insert" => "Back"}]
        },
        "isChallenge" => true,
        "releasedAt" => "2020-01-01T00:00:00Z",
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
          enum: ["flash_card", "multiple_choice", "input", "mark_as_read"],
          description: "Question type"
        },
        prompt: Prompt,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        isChallenge: %Schema{type: :boolean, description: "Is this a challenge question?"},
        releasedAt: %Schema{
          type: :string,
          format: :"date-time",
          description: "When was this question released?"
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
        :name,
        :type,
        :prompt,
        :tags,
        :insertedAt,
        :updatedAt
      ],
      example: %{
        "id" => 1234,
        "organizationId" => 1001,
        "name" => "Question",
        "type" => "flash_card",
        "prompt" => %{
          "front" => [%{"insert" => "Front"}],
          "back" => [%{"insert" => "Back"}]
        },
        "isChallenge" => false,
        "releasedAt" => "2020-01-01T00:00:00Z",
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
          "organizationId" => 1001,
          "name" => "Question",
          "type" => "flash_card",
          "prompt" => %{
            "front" => [%{"insert" => "Front"}],
            "back" => [%{"insert" => "Back"}]
          },
          "isChallenge" => false,
          "releasedAt" => "2020-01-01T00:00:00Z",
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
          "organizationId" => 1001,
          "name" => "Question",
          "type" => "flash_card",
          "prompt" => %{
            "front" => [%{"insert" => "Front"}],
            "back" => [%{"insert" => "Back"}]
          },
          "isChallenge" => false,
          "releasedAt" => "2020-01-01T00:00:00Z",
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
          enum: ["flash_card", "multiple_choice", "input", "mark_as_read"],
          description: "Question type"
        },
        prompt: PromptPrivate,
        tags: %Schema{type: :array, items: %Schema{type: :string}, description: "Question tags"},
        isChallenge: %Schema{
          type: :boolean,
          nullable: true,
          description: "Is this a challenge question?"
        },
        releasedAt: %Schema{
          type: :string,
          format: :"date-time",
          nullable: true,
          description: "When was this question released?"
        },
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
        "tags" => ["math"],
        "isChallenge" => false,
        "releasedAt" => "2020-01-01T00:00:00Z"
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
        isChallenge: %Schema{
          type: :boolean,
          nullable: true,
          description: "Is this a challenge question?"
        },
        releasedAt: %Schema{
          type: :string,
          format: :"date-time",
          nullable: true,
          description: "When was this question released?"
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
        "tags" => ["math", "new-math"],
        "isChallenge" => false,
        "releasedAt" => "2020-01-01T00:00:00Z"
      }
    })
  end
end
