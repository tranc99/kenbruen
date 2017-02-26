defmodule Kenbruen.WatchController do
  use Kenbruen.Web, :controller
  alias Kenbruen.Video

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render conn, "show.html", video: video
  end

end
