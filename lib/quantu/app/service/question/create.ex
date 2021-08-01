defmodule Quantu.App.Service.Question.Create do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:organization, Model.Organization, type: :binary_id)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:organization_id, :type, :prompt, :tags])
    |> validate_required([
      :organization_id,
      :type,
      :prompt
    ])
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Question{}
      |> cast(command, [:organization_id, :type, :prompt, :tags])
      |> validate_required([
        :organization_id,
        :type,
        :prompt
      ])
      |> Repo.insert!()
    end)
  end
end
