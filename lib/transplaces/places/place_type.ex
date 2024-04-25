defmodule Transplaces.Places.PlaceType do
  @moduledoc """
  Place types
  """
  use Transplaces.Schema

  @type id() :: Ecto.UUID.t()

  schema "place_types" do
    field :name, :string
    timestamps()

    many_to_many :places, Transplaces.Places.Place, join_through: "places_place_types"
  end

  def changeset(place_type, attrs) do
    place_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
