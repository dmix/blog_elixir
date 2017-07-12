defmodule Blog.Role do
  use Blog.Web, :model

  schema "roles" do
    field :name, :string
    field :admin, :boolean, default: false

    timestamps()

    has_many :users, Blog.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :admin])
    |> validate_required([:name, :admin])
  end
end
