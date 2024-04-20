defmodule TransplacesWeb.Nav do
  @moduledoc """
  Navigation links and list
  """
  use TransplacesWeb, :html

  @links [
    {"/", "Home"},
    {"/about", "About"},
    {"/contact", "Contact"},
    {"/auth", "Login"},
    {"/auth/delete", "Logout"}
  ]

  def nav(assigns) do
    assigns = assign(assigns, :links, @links)

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
