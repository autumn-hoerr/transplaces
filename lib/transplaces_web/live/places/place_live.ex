defmodule TransplacesWeb.PlaceLive do
  @moduledoc """
  LiveView for the places page
  """
  use TransplacesWeb, :live_view
  alias TransplacesWeb.Ratings.Form

  def mount(%{"id" => id}, _session, socket) do
    socket = assign(socket, :place, Transplaces.Places.get_place(id))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>
        <%= @place.name %>
      </h1>
      <p :if={@place.description}>
        <%= @place.description %>
      </p>
      <p>
        <%= @place.address %>
      </p>
      <Form.form place_id={@place.id} />
    </div>
    """
  end
end
