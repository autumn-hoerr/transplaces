defmodule Transplaces.PlacesTest do
  use Transplaces.DataCase

  alias Transplaces.Places
  alias Transplaces.Places.PlaceTypes

  @valid_attrs %{
    name: "test place",
    description: "A nice place"
  }

  @invalid_attrs %{
    name: nil
  }

  test "list place types" do
    places =
      Enum.map(1..3, fn n ->
        place_type_fixture(%{name: "place type #{n}"})
      end)

    assert PlaceTypes.list_place_types() == places
  end

  test "get place by name" do
    place = place_fixture(%{name: "test"})
    assert Places.get_place_by_name("test") == place
  end

  test "get place" do
    place = place_fixture()
    assert Places.get_place(place.id) == place
  end

  test "get place!" do
    assert_raise Ecto.NoResultsError, fn ->
      Places.get_place!("ce18f36c-e2c5-4058-a13d-eb811b92460c")
    end

    place = place_fixture()
    assert Places.get_place!(place.id) == place
  end

  test "we can get all places through a type" do
    [pt1, pt2, pt3] =
      Enum.map(1..3, fn n ->
        place_type_fixture(%{name: "test type #{n}"})
      end)

    place =
      place_fixture(%{
        name: "hi",
        place_types: %{0 => %{id: pt1.id, name: pt1.name}, 1 => %{id: pt2.id, name: pt2.name}}
      })

    # place2 = place_fixture(%{place_types: %{0 => pt2, 1 => pt3}})
    # place3 = place_fixture(%{place_types: %{0 => pt3, 1 => pt1}})
    # place2 = place_fixture(%{place_types: })
    # place3 = place_fixture(%{place_types: [pt3, pt1]})

    test_type_w_places = PlaceTypes.get_all_places_of_type("test type 1")
    IO.inspect(PlaceTypes.list_place_types())
    # assert Enum.member?(test_type_w_places.places, place)
    # assert Enum.member?(test_type_w_places.places, place3)
    # refute Enum.member?(test_type_w_places.places, place2)
  end

  def place_fixture(attrs \\ %{}) do
    {:ok, place} =
      %{
        name: "test place",
        description: "A nice place",
        place_types: []
      }
      |> Map.merge(attrs)
      |> Places.create_place()

    place
  end

  def place_type_fixture(attrs \\ %{}) do
    {:ok, place_type} =
      %{
        name: "test place type"
      }
      |> Map.merge(attrs)
      |> PlaceTypes.create_place_type()

    place_type
  end
end