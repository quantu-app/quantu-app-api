defmodule Quantu.App.Service.Lesson.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:lesson, Model.Lesson)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:lesson_id, :published])
    |> validate_required([:lesson_id])
    |> foreign_key_constraint(:lesson_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query =
        from(q in Model.Lesson,
          where: q.id == ^command.lesson_id
        )

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [q], q.published == ^command.published)

      Repo.one!(query)
    end)
  end
end
