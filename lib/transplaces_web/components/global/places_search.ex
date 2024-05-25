defmodule TransplacesWeb.PlacesSearch do
  @moduledoc """
  Places search for the nav
  """

  use TransplacesWeb, :live_component

  def places_search(assigns) do
    ~H"""
    <.live_component module={__MODULE__} id="places-search" />
    """
  end

  def mount(socket) do
    socket = assign(socket, :search_form, to_form(%{"q" => ""}))
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@search_form}
        phx-submit="search_submitted"
        phx-change="search_changed"
        phx-target={@myself}
      >
        <.live_select
          placeholder={gettext("Search places")}
          field={@search_form[:q]}
          label=""
          phx-target={@myself}
          phx-focus="clear_search_field"
          debounce="200"
          update_min_len={1}
          dropdown_extra_class="max-h-60 overflow-y-scroll"
        />
      </.simple_form>
    </div>
    """
  end

  @spec handle_event(<<_::112, _::_*16>>, any(), any()) :: {:noreply, any()}
  def handle_event(
        "live_select_change",
        %{"field" => _field, "id" => id, "text" => search_string},
        socket
      ) do
    options =
      Transplaces.Places.search_places(search_string)
      |> Enum.map(fn place -> {place.name, place.id} end)

    send_update(LiveSelect.Component, options: options, id: id)

    {:noreply, socket}
  end

  def handle_event("clear_search_field", %{"id" => id}, socket) do
    send_update(LiveSelect.Component, options: [], id: id)
    {:noreply, socket}
  end

  def handle_event("search_changed", %{"q" => place_id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/places/#{place_id}")}
  end

  def handle_event("search_submitted", _params, socket) do
    {:noreply, socket}
  end
end
