defmodule Kenbruen.PageControllerTest do
  use Kenbruen.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) != "Welcome to Kenbruen!"
  end
end
