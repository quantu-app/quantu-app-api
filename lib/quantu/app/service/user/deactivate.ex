defmodule Quantu.App.Service.User.Deactivate do
  use Aicacia.Handler

  alias Quantu.App.Model
  alias Quantu.App.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.user_id)
      |> change(%{active: false})
      |> Repo.update!()
      |> Repo.preload([:emails])
    end)
  end
end
