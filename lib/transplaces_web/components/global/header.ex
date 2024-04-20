defmodule TransplacesWeb.HeaderLive do
  @moduledoc """
  Header display
  """
  use TransplacesWeb, :live_component
  import TransplacesWeb.Nav

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <header>
      <h1>TransPlaces</h1>
      <.nav />
    </header>
    """
  end
end
