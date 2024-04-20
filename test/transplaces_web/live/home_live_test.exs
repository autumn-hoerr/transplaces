defmodule TransplacesWeb.HomeLiveTest do
  use TransplacesWeb.ConnCase

  import Phoenix.LiveViewTest

  test "render live component", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")
    assert view
    assert view |> element("main") |> render() =~ "Welcome"
  end
end
