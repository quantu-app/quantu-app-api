defmodule Quantu.App.Service.Quiz.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo, Service}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    belongs_to(:unit, Model.Unit)
    field(:name, :string, null: false)
    field(:description, {:array, :map}, null: false, default: [])
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :unit_id, :name, :description, :tags, :published])
    |> validate_required([
      :organization_id,
      :name
    ])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      quiz =
        %Model.Quiz{}
        |> cast(command, [:organization_id, :name, :description, :tags, :published])
        |> validate_required([
          :organization_id,
          :name
        ])
        |> Repo.insert!()

      if Map.get(command, :unit_id) == nil do
        quiz
        |> Map.put(:type, :quiz)
      else
        Service.Unit.Create.create_unit_child_join!(quiz, command.unit_id)
      end
    end)
  end
end
