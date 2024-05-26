defmodule TransplacesWeb.Nav do
  @moduledoc """
  Navigation links and list
  """
  use TransplacesWeb, :html
  alias TransplacesWeb.PlacesSearch

  def nav(assigns) do
    assigns =
      assign(assigns, :links, [
        {~p"/", "Home"},
        {~p"/places", "Places"},
        {~p"/auth/discord", "Login"},
        {~p"/auth/delete", "Logout"}
      ])

    ~H"""
    <nav>
      <PlacesSearch.places_search />
      <ul>
        <li :for={{path, name} <- @links}>
          <a href={"#{path}"}><%= name %></a>
        </li>
      </ul>
    </nav>
    """
  end
end
