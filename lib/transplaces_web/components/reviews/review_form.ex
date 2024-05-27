defmodule TransplacesWeb.Ratings.Form do
  use TransplacesWeb, :live_component

  alias Transplaces.Ratings
  alias Transplaces.Ratings.Rating
  alias TransplacesWeb.Components.Reviews.RatingScaleField

  attr :place_id, :string, required: true

  def form(assigns) do
    ~H"""
    <.live_component module={__MODULE__} id="rating-form" place_id={@place_id} />
    """
  end

  def mount(socket) do
    socket = assign(socket, rating_form: to_form(Transplaces.Ratings.rating_changeset()))
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h2><%= gettext("Leave a Rating") %></h2>
      <.simple_form
        for={@rating_form}
        phx-change="validate"
        phx-submit="save_rating"
        phx-target={@myself}
      >
        <.input type="hidden" field={@rating_form[:place_id]} value={@place_id} />
        <RatingScaleField.scale_input
          field={@rating_form[:trans_friendliness_rating]}
          label={gettext("Trans Friendliness Rating")}
        />
        <RatingScaleField.scale_input
          field={@rating_form[:accessibility_rating]}
          label={gettext("Accessibility Rating")}
        />
        <RatingScaleField.scale_input
          field={@rating_form[:employer_rating]}
          label={gettext("Employer Rating")}
        />
        <RatingScaleField.scale_input
          field={@rating_form[:overall_rating]}
          label={gettext("Overall Rating")}
        />
        <:actions>
          <.link phx-target={@myself} phx-click="reset_form"><%= gettext("Reset") %></.link>
          <.button><%= gettext("Submit") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("reset_form", _, socket) do
    {:noreply, assign(socket, rating_form: to_form(Transplaces.Ratings.rating_changeset()))}
  end

  def handle_event("save_rating", %{"rating" => rating_params}, socket) do
    case Ratings.create_rating(rating_params) do
      {:ok, _rating} ->
        socket =
          socket
          |> put_flash(:success, gettext("Rating added!"))
          |> assign(rating_form: to_form(Transplaces.Ratings.rating_changeset()))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> put_flash(:error, gettext("Couldn't add rating, check for errors."))
          |> assign(rating_form: to_form(changeset))

        {:noreply, socket}
    end

    {:noreply, socket}
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    changeset = Rating.changeset(%Rating{}, rating_params)

    {:noreply, assign(socket, rating_form: to_form(changeset))}
  end
end
