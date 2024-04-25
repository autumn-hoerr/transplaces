defmodule Transplaces.Places.Place do
  @moduledoc """
  Place
  """
  use Transplaces.Schema

  @type id() :: Ecto.UUID.t()

  schema "places" do
    field :googlePlaceId, :string
    field :name, :string
    field :address, :string
    field :description, :string
    field :accessibilityOptions, :string
    field :primaryType, :string
    field :minorityOwned, :boolean
    field :womanOwned, :boolean
    field :lgbtqOwned, :boolean
    timestamps()

    many_to_many :place_types, Transplaces.Places.PlaceType, join_through: "places_place_types"
    has_many :ratings, Transplaces.Ratings.Rating
    has_many :comments, Transplaces.Ratings.Comment
  end

  def changeset(%Ecto.Changeset{} = place, attrs) do
    place
    |> cast(attrs, [
      :googlePlaceId,
      :name,
      :address,
      :description,
      :accessibilityOptions,
      :primaryType,
      :minorityOwned,
      :womanOwned,
      :lgbtqOwned
    ])
    |> cast_assoc(:place_types)
    |> validate_required([:name])
  end

  def changeset(%__MODULE__{} = place, attrs) do
    place
    |> cast(attrs, [
      :googlePlaceId,
      :name,
      :address,
      :description,
      :accessibilityOptions,
      :primaryType,
      :minorityOwned,
      :womanOwned,
      :lgbtqOwned
    ])
    |> cast_assoc(:place_types)
    |> validate_required([:name])
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
