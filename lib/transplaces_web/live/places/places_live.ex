defmodule TransplacesWeb.PlacesLive do
  @moduledoc """
  LiveView for the places page
  """
  use TransplacesWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :places, Transplaces.Places.list_a_few_places())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Places</h1>
      <ul>
        <li :for={place <- @places}>
          <.link href={~p"/places/#{place.id}"}><%= place.name %></.link>
        </li>
      </ul>
    </div>
    """
  end
end
