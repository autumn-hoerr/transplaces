defmodule Transplaces.Connectors.GooglePlaces do
  @moduledoc """
  Google Places API connector
  """

  require Decimal

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
      # 50 miles in meters
      radius: Decimal.mult(50, 1609)
    }
  }

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
        {"X-Goog-Api-Key", ""},
        {"X-Goog-FieldMask", "places.displayName,places.formattedAddress"}
      ])

    IO.inspect(r)
  end

  defp get_url(endpoint), do: @url <> endpoint
end
