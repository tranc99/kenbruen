defmodule Kenbruen.UserController do
  use Kenbruen.Web, :controller
  import Kenbruen.UserView

  def index(conn, _params) do
    users = Repo.all(Kenbruen.User)
    render conn, "index.html", users: users
  end
end
