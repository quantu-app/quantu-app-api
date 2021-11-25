defmodule Quantu.App.Service.Unit.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:unit, Model.Unit)
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:unit_id, :published])
    |> validate_required([:unit_id])
    |> foreign_key_constraint(:unit_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query =
        from(q in Model.Unit,
          where: q.id == ^command.unit_id
        )

      query =
        if Map.get(command, :published) == nil,
          do: query,
          else: where(query, [q], q.published == ^command.published)

      Repo.one!(query)
    end)
  end

  def unit_children(%Model.Unit{id: unit_id}) do
    from(c in Model.UnitChildJoin,
      preload: [:quiz, :lesson],
      where: c.unit_id == ^unit_id,
      order_by: [asc: c.index]
    )
    |> Repo.all()
    |> Enum.map(&map_child/1)
  end

  def unit_children(nil), do: []

  defp map_child(%Model.UnitChildJoin{
         unit_id: unit_id,
         index: index,
         quiz: %Model.Quiz{} = child
       }),
       do: child |> Map.put(:unit_id, unit_id) |> Map.put(:index, index)

  defp map_child(%Model.UnitChildJoin{
         unit_id: unit_id,
         index: index,
         lesson: %Model.Lesson{} = child
       }),
       do: child |> Map.put(:unit_id, unit_id) |> Map.put(:index, index)
end
