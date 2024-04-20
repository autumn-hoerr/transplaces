defmodule Transplaces.Connectors.GooglePlaces do
  @moduledoc """
  Google Places API connector
  """
  @ilm_lat "34.2071359"
  @ilm_long "-77.87207"
  @default_results_count 10
  @url "https://places.googleapis.com/v1"
  @searchNearby "/places:searchNearby"
  @placeDetails "/places/"
  @locationRestriction %{
    circle: %{
      center: %{
        latitude: @ilm_lat,
        longitude: @ilm_long
      },
      radius: "50"
    }
  }

  def search_nearby(query \\ %{}) do
    url = get_url(@searchNearby)

    body =
      query
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
