defmodule Transplaces.Places.PlaceType do
  @moduledoc """
  Place types
  """
  use Transplaces.Schema
  alias Transplaces.Places

  @type id() :: Ecto.UUID.t()

  schema "place_types" do
    field :name, :string
    field :places_list, {:array, :integer}, default: [], virtual: true
    timestamps()

    many_to_many :places, Transplaces.Places.Place, join_through: "places_place_types"
  end

  def changeset(place_type, attrs) do
    place_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> maybe_put_place(attrs)
    |> unique_constraint(:name)
  end

  # i don't really expect this to be used, but it's here
  defp maybe_put_place(changeset, %{places_list: []}), do: changeset

  defp maybe_put_place(changeset, attrs) do
    IO.inspect(attrs)
    places = Places.get_places(attrs[:places_list])
    put_assoc(changeset, :places, places)
  end
end
