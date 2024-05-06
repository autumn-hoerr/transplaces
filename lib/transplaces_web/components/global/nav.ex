defmodule TransplacesWeb.Nav do
  @moduledoc """
  Navigation links and list
  """
  use TransplacesWeb, :html

  def nav(assigns) do
    assigns =
      assign(assigns, :links, [
        {~p"/", "Home"},
        {~p"/auth/discord", "Login"},
        {~p"/auth/delete", "Logout"}
      ])

    ~H"""
    <nav>
      <ul>
        <li :for={{path, name} <- @links}>
          <a href={"#{path}"}><%= name %></a>
        </li>
      </ul>
    </nav>
    """
  end
end
