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

    place1 =
      place_fixture(%{
        name: "Place 1",
        place_types_list: [pt1.id, pt2.id]
      })

    place2 =
      place_fixture(%{
        name: "Place 2",
        place_types_list: [pt2.id, pt3.id]
      })

    place3 =
      place_fixture(%{
        name: "Place 3",
        place_types_list: [pt3.id, pt1.id]
      })

    test_type_w_places = PlaceTypes.get_all_places_of_type("test type 1")

    assert test_type_w_places.places |> Enum.map(& &1.name) |> Enum.member?(place1.name)
    assert test_type_w_places.places |> Enum.map(& &1.name) |> Enum.member?(place3.name)
    refute test_type_w_places.places |> Enum.map(& &1.name) |> Enum.member?(place2.name)
  end

  def place_fixture(attrs \\ %{}) do
    {:ok, place} =
      %{
        name: "test place",
        description: "A nice place",
        place_types_list: []
      }
      |> Map.merge(attrs)
      |> Places.create_place()

    place
  end

  def place_type_fixture(attrs \\ %{}) do
    {:ok, place_type} =
      %{
        name: "test place type",
        places_list: []
      }
      |> Map.merge(attrs)
      |> PlaceTypes.create_place_type()

    place_type
  end
end
