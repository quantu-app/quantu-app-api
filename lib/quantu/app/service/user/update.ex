defmodule Quantu.App.Service.User.Update do
  use Aicacia.Handler

  alias Quantu.App.Model
  alias Quantu.App.Repo
  alias Quantu.App.Service

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:username, :string, null: false)
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:user_id, :username])
    |> validate_format(:username, Service.User.Create.username_regex())
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.user_id)
      |> cast(
        command,
        [:username]
      )
      |> unique_constraint(:username)
      |> Repo.update!()
      |> Repo.preload([:emails])
    end)
  end
end
