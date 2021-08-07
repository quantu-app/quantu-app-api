defmodule Quantu.App.Service.Organization.Index do
  use Aicacia.Handler
  import Ecto.Query

  alias Quantu.App.{Model, Repo}

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id])
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      if Map.get(command, :user_id) == nil do
        Repo.all(Model.Organization)
      else
        from(b in Model.Organization,
          where:
            b.user_id ==
              ^command.user_id
        )
        |> Repo.all()
      end
    end)
  end
end
