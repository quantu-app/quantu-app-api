defmodule Quantu.App.Service.User.Show do
  use Aicacia.Handler
  import Ecto.Query

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
      get_user!(command.user_id)
    end)
  end

  def get_user!(user_id),
    do:
      from(u in Model.User,
        where: u.id == ^user_id,
        preload: [:emails]
      )
      |> Repo.one!()
end
