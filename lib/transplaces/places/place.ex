defmodule Transplaces.Places.Place do
  @moduledoc """
  Place
  """
  use Transplaces.Schema

  # alias Transplaces.Places
  alias Transplaces.Places.PlaceTypes

  @type id() :: Ecto.UUID.t()

  @derive {
    Flop.Schema,
    filterable: [:name, :primary_type], sortable: [:name, :primary_type]
  }

  schema "places" do
    field :googlePlaceId, :string
    field :name, :string
    field :address, :string
    field :description, :string
    field :accessibility_opts, :map
    field :primary_type, :string
    field :minorityOwned, :boolean
    field :womanOwned, :boolean
    field :lgbtqOwned, :boolean
    field :place_types_list, {:array, :integer}, default: [], virtual: true
    timestamps()

    many_to_many :place_types, Transplaces.Places.PlaceType, join_through: "places_place_types"
    has_many :ratings, Transplaces.Ratings.Rating
    has_many :comments, Transplaces.Ratings.Comment
  end

  def changeset(place \\ %__MODULE__{}, attrs) do
    allowed = [
      :googlePlaceId,
      :name,
      :address,
      :description,
      :accessibility_opts,
      :primary_type,
      :minorityOwned,
      :womanOwned,
      :lgbtqOwned
    ]

    required = [:name, :address]

    place
    |> cast(attrs, allowed)
    |> maybe_put_place_types(attrs)
    |> validate_required(required)
    |> unique_constraint([:name, :address])
  end

  defp maybe_put_place_types(changeset, %{place_types_list: []} = _attrs), do: changeset

  defp maybe_put_place_types(changeset, attrs) do
    placetypes = PlaceTypes.get_place_types(attrs[:place_types_list])
    put_assoc(changeset, :place_types, placetypes)
  end
end

# fields from google places api
# @basic_fields = [
#   places.accessibilityOptions,
#   places.addressComponents,
#   places.adrFormatAddress,
#   places.businessStatus,
#   places.displayName,
#   places.formattedAddress,
#   places.googleMapsUri,
#   places.iconBackgroundColor,
#   places.iconMaskBaseUri,
#   places.id,
#   places.location,
#   places.name*,
#   places.photos,
#   places.plusCode,
#   places.primaryType,
#   places.primaryTypeDisplayName,
#   places.shortFormattedAddress,
#   places.subDestinations,
#   places.types,
#   places.utcOffsetMinutes,
#   places.viewport ]

# @advanced_fields = [
#    places.currentOpeningHours,
#    places.currentSecondaryOpeningHours,
#    places.internationalPhoneNumber,
#    places.nationalPhoneNumber,
#    places.priceLevel,
#    places.rating,
#    places.regularOpeningHours,
#    places.regularSecondaryOpeningHours,
#    places.userRatingCount,
#    places.websiteUri
# ]

# @preferred_fields = [
#   places.allowsDogs,
#   places.curbsidePickup,
#   places.delivery,
#   places.dineIn,
#   places.editorialSummary,
#   places.evChargeOptions,
#   places.fuelOptions,
#   places.goodForChildren,
#   places.goodForGroups,
#   places.goodForWatchingSports,
#   places.liveMusic,
#   places.menuForChildren,
#   places.parkingOptions,
#   places.paymentOptions,
#   places.outdoorSeating,
#   places.reservable,
#   places.restroom,
#   places.reviews,
#   places.servesBeer,
#   places.servesBreakfast,
#   places.servesBrunch,
#   places.servesCocktails,
#   places.servesCoffee,
#   places.servesDesserts,
#   places.servesDinner,
#   places.servesLunch,
#   places.servesVegetarianFood,
#   places.servesWine,
#   places.takeout
# ]
