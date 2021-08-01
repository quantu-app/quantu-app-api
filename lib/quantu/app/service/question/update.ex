defmodule Quantu.App.Service.Question.Update do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:question, Model.Question, type: :binary_id)
    field(:type, :string, null: false)
    field(:prompt, :map, null: false)
    field(:tags, {:array, :string}, null: false, default: [])
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :question_id,
      :type,
      :prompt,
      :tags
    ])
    |> validate_required([
      :question_id,
      :type,
      :prompt,
      :tags
    ])
    |> foreign_key_constraint(:question_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Question, id: command.question_id)
      |> cast(command, [:type, :prompt, :tags])
      |> Repo.update!()
    end)
  end
end
