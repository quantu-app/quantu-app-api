defmodule Quantu.App.Guard.Organization.Write do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:organization, Model.Organization)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([
      :user_id,
      :organization_id
    ])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:organization_id)
  end

  def handle(%{} = command) do
    case from(o in Model.Organization,
           where: o.id == ^command.organization_id and o.user_id == ^command.user_id
         )
         |> Repo.one() do
      nil ->
        {:error, %Ecto.NoResultsError{}}

      _organization ->
        {:ok, nil}
    end
  end
end
