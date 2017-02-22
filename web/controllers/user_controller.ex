defmodule Kenbruen.UserController do
  use Kenbruen.Web, :controller
  import Kenbruen.UserView

  def index(conn, _params) do
    users = Repo.all(Kenbruen.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Kenbruen.User, id)
    render conn, "show.html", user: user
  end
end
