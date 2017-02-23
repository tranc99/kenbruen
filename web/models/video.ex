defmodule Kenbruen.Video do
  use Kenbruen.Web, :model

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    belongs_to :user, Kenbruen.User
    belongs_to :category, Kenbruen.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
  end
end
