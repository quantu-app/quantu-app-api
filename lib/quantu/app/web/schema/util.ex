defmodule Quantu.App.Web.Schema.Util do
  alias OpenApiSpex.Schema

  defmodule HealthCheck do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "HealthCheck",
      description: "health check",
      type: :object,
      properties: %{
        ok: %Schema{type: :boolean, description: "ok status"}
      },
      additionalProperties: false,
      required: [:ok],
      example: %{
        "ok" => true
      }
    })
  end
end
