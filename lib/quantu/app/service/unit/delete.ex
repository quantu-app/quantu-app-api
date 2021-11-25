defmodule Quantu.App.Service.Unit.Delete do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:unit, Model.Unit)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:unit_id])
    |> validate_required([:unit_id])
    |> foreign_key_constraint(:unit_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.Unit, command.unit_id)
      |> Repo.delete!()
    end)
  end
end
