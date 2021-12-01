defmodule Quantu.App.Repo.Migrations.UpdateDescriptions do
  use Ecto.Migration

  alias Quantu.App.{Repo, Model}

  defmacrop update_description(table, model) do
    quote do
      alter table(unquote(table)) do
        add(:json_description, {:array, :map}, null: false, default: [])
      end

      flush()

      Repo.all(unquote(model))
      |> Enum.each(fn row ->
        row
        |> Ecto.Changeset.change(%{ json_description: [%{insert: row.description}]})
        |> Repo.update()
      end)

      alter table unquote(table) do
        remove :description
      end
      rename table(unquote(table)), :json_description, to: :description
    end
  end

  def change do
    update_description(:courses, Model.Course)
    update_description(:units, Model.Unit)
    update_description(:quizzes, Model.Quiz)
    update_description(:lessons, Model.Lesson)
  end
end
