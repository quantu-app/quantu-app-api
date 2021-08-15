defmodule Quantu.App.Service.Organization.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:subscriptions, :boolean, default: false)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :subscriptions])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      query = Model.Organization

      query =
        if Map.get(command, :user_id) != nil do
          where(query, [o], o.user_id == ^command.user_id)
        else
          query
        end

      query =
        if Map.get(command, :subscriptions) == true do
          join(query, :inner, [o], s in Model.UserOrganizationSubscription,
            on: s.user_id == o.user_id
          )
        else
          query
        end

      Repo.all(query)
    end)
  end
end
