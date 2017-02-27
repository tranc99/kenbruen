defmodule Kenbruen.Video do
  use Kenbruen.Web, :model

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :slug, :string
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
    |> slugify_title()
    |> assoc_constraint(:category)
  end

  defp slugify_title do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, :slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
    string
    |> String.downcase
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
