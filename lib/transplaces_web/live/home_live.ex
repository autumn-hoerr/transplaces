defmodule TransplacesWeb.HomeLive do
  @moduledoc """
  LiveView for the home page
  """
  use TransplacesWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h2>Welcome to TransPlaces</h2>
      <p>
        TransPlaces is a private resource for the Wilmington area trans community to share experiences at local businesses.
      </p>
      <p>Access is only granted through the Discord server</p>
      <p><.link href={~p"/auth/discord"}>Log in with Discord</.link></p>
    </div>
    """
  end
end
