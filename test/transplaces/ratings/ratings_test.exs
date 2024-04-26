defmodule Transplaces.RatingTest do
  use Transplaces.DataCase

  alias Transplaces.Ratings
  alias Transplaces.Places

  setup do
    place = place_fixture()

    %{place: place}
  end

  test "can be retrieved by ID", %{place: place} do
    rating = rating_fixture(%{place_id: place.id})
    assert Ratings.get_rating(rating.id) == rating
  end

  test "will throw an error for a missing rating" do
    assert_raise Ecto.NoResultsError, fn ->
      Ratings.get_rating!("ce18f36c-e2c5-4058-a13d-eb811b92460c")
    end
  end

  test "can be retrieved by place ID", %{place: place} do
    rating = rating_fixture(%{place_id: place.id})
    assert Ratings.get_ratings_for_place(place.id) == [rating]
  end

  # TBD if this is how we actually want to do this. It might be better
  # to check that one of them is not nil instead of the total > 0
  test "will complain if all zeroes are provided", %{place: place} do
    {:error, changeset} =
      Ratings.create_rating(%{
        trans_friendliness_rating: 0,
        accessibility_rating: 0,
        overall_rating: 0,
        employer_rating: 0,
        place_id: place.id
      })

    assert changeset.valid? == false

    assert changeset.errors == [
             trans_friendliness_rating: {"At least one rating must be provided", []}
           ]
  end

  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      %{
        trans_friendliness_rating: 5,
        accessibility_rating: 5,
        overall_rating: 5,
        employer_rating: 5
      }
      |> Map.merge(attrs)
      |> Ratings.create_rating()

    rating
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
end
