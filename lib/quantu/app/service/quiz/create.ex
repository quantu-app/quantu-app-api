defmodule Quantu.App.Service.Quiz.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization)
    field(:name, :string, null: false)
    field(:description, :string, null: false, default: "")
    field(:tags, {:array, :string}, null: false, default: [])
    field(:published, :boolean)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :name, :description, :tags, :published])
    |> validate_required([
      :organization_id,
      :name
    ])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Quiz{}
      |> cast(command, [:organization_id, :name, :description, :tags, :published])
      |> validate_required([
        :organization_id,
        :name
      ])
      |> Repo.insert!()
    end)
  end
end
