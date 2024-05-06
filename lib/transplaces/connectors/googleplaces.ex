defmodule Transplaces.Connectors.GooglePlaces do
  @moduledoc """
  Google Places API connector
  """

  require Decimal
  alias Transplaces.Places.PlaceTypes
  alias Transplaces.Places
  alias Transplaces.Repo
  alias Transplaces.Connectors.Epicenters
  alias Transplaces.Connectors.GoogleTypes

  # 20 is the max results per request
  @default_results_count 20
  @url "https://places.googleapis.com/v1"
  @searchNearby "/places:searchNearby"
  # @placeDetails "/places/"
  @fieldsWanted [
    "places.id",
    "places.displayName",
    "places.formattedAddress",
    "places.editorialSummary",
    "places.accessibilityOptions",
    "places.primaryType",
    "places.types"
  ]

  def update_places() do
    locations = Epicenters.locations()
    types = GoogleTypes.google_types()

    Enum.each(locations, fn location ->
      Enum.each(types, fn type ->
        search_nearby(type, location)
      end)
    end)
  end

  # def search_test(type, location),
  #   do: IO.inspect({type, location_restriction(location)}, label: "dry run")

  def search_nearby(type, location) do
    url = get_url(@searchNearby)
    # now = Date.utc_today() |> Date.to_string()
    # file_name = "googleplaces-#{type}-#{now}.json"

    body =
      %{}
      |> Map.merge(%{includedTypes: type})
      |> Map.merge(%{locationRestriction: location_restriction(location)})
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
            # |> save_response_to_file(file_name)
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

  defp save_places(nil), do: :ok

  defp save_places(response) do
    response
    |> Enum.each(fn place ->
      place
      |> extract_and_save_placetypes()
      |> save_place()
    end)
  end

  defp save_place(nil), do: :ok

  defp save_place(place) do
    place
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      {dbkey, value} = response_field_to_db_field(key, place)
      Map.put(acc, dbkey, value)
    end)
    |> Places.create_place()
  end

  defp extract_and_save_placetypes(nil), do: :ok

  defp extract_and_save_placetypes(place) do
    place
    |> Map.get("types")
    # construct an ecto.multi to do this all at once
    |> PlaceTypes.create_place_types()
    |> Repo.transaction()

    place
  end

  defp location_restriction(location) do
    %{
      circle: %{
        center: location,
        # 30 miles in meters, 50000 meters max api limit
        radius: Decimal.mult(30, 1609)
      }
    }
  end

  # defp save_response_to_file(response, filename) do
  #   File.write!(filename, Jason.encode!(response))

  #   response
  # end

  defp response_field_to_db_field("id" = key, place) do
    {:googlePlaceId, place[key]}
  end

  defp response_field_to_db_field("displayName" = key, place) do
    {:name, place[key]["text"]}
  end

  defp response_field_to_db_field("formattedAddress" = key, place) do
    {:address, place[key]}
  end

  defp response_field_to_db_field("editorialSummary" = key, place) do
    {:description, place[key]["text"]}
  end

  defp response_field_to_db_field("primaryType" = key, place) do
    {:primaryType, place[key]}
  end

  defp response_field_to_db_field("types" = key, place) do
    # these already exist in the db, so we just need to get the ids
    {:place_types_list, PlaceTypes.ids_from_names(place[key])}
  end

  defp response_field_to_db_field("accessibilityOptions" = key, place) do
    {:accessibility_opts, place[key]}
  end

  defp response_field_to_db_field(key, place), do: {String.to_existing_atom(key), place[key]}

  defp get_url(endpoint), do: @url <> endpoint
end
