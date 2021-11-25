defmodule Quantu.App.Service.Unit.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:unit, Model.Unit)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:unit_id, :name, :description, :tags, :published])
    |> validate_required([:unit_id])
    |> foreign_key_constraint(:unit_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Unit, id: command.unit_id)
      |> cast(command, [:name, :description, :tags, :published])
      |> Repo.update!()
    end)
  end
end
