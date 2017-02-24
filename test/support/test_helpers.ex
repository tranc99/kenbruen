defmodule Kenbruen.TestHelpers do
  alias Kenbruen.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
        name: "Some User",
        username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
        password: "supersecret"
      }, attrs)

    %Kenbruen.User{}
    |> Kenbruen.User.registration_changeset(changes)
    |> Repo.insert!()
  end


  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end

end
