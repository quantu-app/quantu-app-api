defmodule Quantu.App.Service.Email.SetPrimary do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.Model
  alias Quantu.App.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :email_id])
    |> validate_required([:user_id, :email_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:email_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      from(e in Model.Email, where: e.user_id == ^command.user_id)
      |> Repo.update_all(set: [primary: false])

      Repo.get_by!(Model.Email, id: command.email_id, user_id: command.user_id)
      |> cast(
        %{primary: true},
        [:primary]
      )
      |> Repo.update!()
    end)
  end
end
