defmodule Kenbruen.AnnotationView do
  use Kenbruen.Web, :view

  def render("annotation.json", %{annotation: ann}) do
    %{
      id: ann.id,
      body: ann.body,
      at: ann.at,
      user: render_one(ann.user, Kenbruen.UserView, "user.json")
    }
  end
end
