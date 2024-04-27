defmodule Transplaces.Connectors.GooglePlaces do
  @moduledoc """
  Google Places API connector
  """

  require Decimal
  alias Transplaces.Places.PlaceTypes
  alias Transplaces.Repo

  @ilm_lat 34.2071359
  @ilm_long -77.87207
  @default_results_count 10
  @url "https://places.googleapis.com/v1"
  @searchNearby "/places:searchNearby"
  # @placeDetails "/places/"
  @locationRestriction %{
    circle: %{
      center: %{
        latitude: @ilm_lat,
        longitude: @ilm_long
      },
      # 30 miles in meters, 50000 meters max api limit
      radius: Decimal.mult(30, 1609)
    }
  }
  @fieldsWanted [
    "places.displayName",
    "places.formattedAddress",
    "places.editorialSummary",
    "places.accessibilityOptions",
    "places.primaryType",
    "places.types"
  ]

  def search_nearby_ilm() do
    url = get_url(@searchNearby)

    body =
      %{}
      |> Map.merge(%{includedTypes: "restaurant"})
      |> Map.merge(%{locationRestriction: @locationRestriction})
      |> Map.merge(%{maxResultCount: @default_results_count})
      |> Jason.encode!()

    r =
      HTTPoison.post(url, body, [
        {"Content-Type", "application/json"},
        {"X-Goog-Api-Key", Application.get_env(:transplaces, :google_places_api_key)},
        {"X-Goog-FieldMask", Enum.join(@fieldsWanted, ",")}
      ])

    case r do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, places} ->
            Map.get(places, "places")
            |> save_places()

          {:error, reason} ->
            IO.inspect(reason, label: "error decoding places")
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("404")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason, label: "places API request error")
    end
  end

  defp save_places(response) do
    response
    |> Enum.each(fn place ->
      place
      # |> extract_and_save_placetypes()
      |> save_place()
    end)
  end

  defp save_place(place) do
    place
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(acc, key, response_field_to_db_field(key, place))
    end)
  end

  # defp extract_and_save_placetypes(place) do
  #   place
  #   |> Map.get("types")
  #   # construct an ecto.multi to do this all at once
  #   |> PlaceTypes.create_place_types()
  #   # insert the place types?
  #   |> Repo.transaction()

  #   place
  # end

  defp response_field_to_db_field("displayName" = key, place) do
    place[key]["text"]
  end

  defp response_field_to_db_field("formattedAddress" = key, place) do
    place[key]
  end

  defp response_field_to_db_field("editorialSummary" = key, place) do
    place[key]["text"]
  end

  defp response_field_to_db_field("primaryType" = key, place) do
    place[key]
  end

  defp response_field_to_db_field("types" = key, place) do
    PlaceTypes.ids_from_names(place[key])
  end

  defp get_url(endpoint), do: @url <> endpoint
end

# field :googlePlaceId, :string
# field :name, :string
# field :address, :string
# field :description, :string
# field :accessibilityOptions, :string
# field :primaryType, :string
# field :minorityOwned, :boolean
# field :womanOwned, :boolean
# field :lgbtqOwned, :boolean
# field :place_types_list, {:array, :integer}, default: [], virtual: true
# timestamps()

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
