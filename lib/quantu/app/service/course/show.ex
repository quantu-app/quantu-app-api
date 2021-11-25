defmodule Quantu.App.Service.Course.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:course, Model.Course)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:course_id, :published])
    |> validate_required([:course_id])
    |> foreign_key_constraint(:course_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query =
        from(q in Model.Course,
          where: q.id == ^command.course_id
        )

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [q], q.published == ^command.published)

      Repo.one!(query)
    end)
  end
end
