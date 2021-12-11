defmodule Quantu.App.Repo.Migrations.UpdateDescriptions do
  use Ecto.Migration
  import Ecto.Query

  alias Quantu.App.Repo

  defmacrop update_description(table) do
    quote do
      alter table(unquote(table)) do
        add(:json_description, {:array, :map}, null: false, default: [])
      end

      flush()

      Repo.all(from(r in to_string(unquote(table)), select: [:id, :description]))
      |> Enum.each(fn row ->
        from(to_string(unquote(table)),
          where: [id: ^row.id],
          update: [set: [json_description: ^[%{insert: row.description}]]]
        )
        |> Repo.update_all([])
      end)

      alter table(unquote(table)) do
        remove :description
      end

      rename table(unquote(table)), :json_description, to: :description
    end
  end

  def change do
    update_description(:courses)
    update_description(:units)
    update_description(:quizzes)
    update_description(:lessons)
  end
end
