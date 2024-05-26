defmodule TransplacesWeb.Components.Reviews.RatingScaleField do
  @moduledoc """
  Renders a radio button likert scale. Defaults to 5 options,
  but can be overriden by passing a scale attr

  ## Examples

      <.rating_scale_field scale={6} field={@form[:rating]} label="Rating" />
  """
  use TransplacesWeb, :html

  @scale 5

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :scale, :integer, default: @scale

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def scale_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> scale_input()
  end

  def scale_input(%{value: value} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <div class="flex flex-row items-center gap-3 mt-2">
        <div><%= gettext("worst") %></div>
        <div :for={i <- 1..@scale} class="flex flex-col text-center">
          <label for={@id <> "-#{i}"}><%= i %></label>
          <input type="radio" name={@name} id={@id <> "-#{i}"} value={i} checked={i == value} {@rest} />
        </div>
        <div><%= gettext("best") %></div>
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end
end
