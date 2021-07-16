defmodule Quantu.App.Service.Journel.Show do
  use Aicacia.Handler

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:journel, Model.Journel, type: :binary_id)
    belongs_to(:user, Model.User, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:journel_id, :user_id])
    |> validate_required([:journel_id, :user_id])
    |> foreign_key_constraint(:journel_id)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Journel, id: command.journel_id, user_id: command.user_id)
    end)
  end
end
