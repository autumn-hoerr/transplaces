defmodule Transplaces.RatingTest do
  use Transplaces.DataCase

  alias Transplaces.Ratings
  alias Transplaces.Places

  require Decimal

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

  test "will complain if all nils are provided", %{place: place} do
    {:error, changeset} =
      Ratings.create_rating(%{
        trans_friendliness_rating: nil,
        accessibility_rating: nil,
        overall_rating: nil,
        employer_rating: nil,
        place_id: place.id
      })

    assert changeset.valid? == false

    assert changeset.errors == [
             trans_friendliness_rating: {"At least one rating must be provided", []}
           ]
  end

  test "one rating is enough to pass validation", %{place: place} do
    {:ok, rating} =
      Ratings.create_rating(%{
        trans_friendliness_rating: 0,
        accessibility_rating: nil,
        overall_rating: nil,
        employer_rating: nil,
        place_id: place.id
      })

    assert rating.trans_friendliness_rating == 0
    assert rating.accessibility_rating == nil
  end

  test "can return a properly computed average rating", %{place: place} do
    _rating1 =
      rating_fixture(%{
        trans_friendliness_rating: 4,
        accessibility_rating: 4,
        overall_rating: 4,
        employer_rating: 4,
        place_id: place.id
      })

    _rating2 =
      rating_fixture(%{
        trans_friendliness_rating: 2,
        accessibility_rating: 2,
        overall_rating: 2,
        employer_rating: 2,
        place_id: place.id
      })

    assert %{
             total_ratings: 2,
             trans_friendliness_average: Decimal.new("3.0000000000000000"),
             accessibility_rating: Decimal.new("3.0000000000000000"),
             overall_average: Decimal.new("3.0000000000000000"),
             employer_average: Decimal.new("3.0000000000000000")
           } == Ratings.with_average_ratings_for_place(place.id)
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
