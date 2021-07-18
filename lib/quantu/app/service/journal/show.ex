defmodule Quantu.App.Service.Journal.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:journal, Model.Journal, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:journal_id, :user_id])
    |> validate_required([:journal_id, :user_id])
    |> foreign_key_constraint(:journal_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Journal, id: command.journal_id, user_id: command.user_id)
    end)
  end
end
