defmodule Transplaces.Ratings do
  @moduledoc """
  Ratings and reviews
  """
  import Ecto.Query
  alias Transplaces.Repo
  alias Transplaces.Ratings.Rating

  def get_rating(rating_id) do
    Repo.get(Rating, rating_id)
  end

  def get_rating!(rating_id) do
    Repo.get!(Rating, rating_id)
  end

  def get_ratings_for_place(place_id) do
    Repo.all(from r in Rating, where: r.place_id == ^place_id)
  end

  def create_rating(attrs) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  def rating_changeset(rating \\ %Rating{}, attrs \\ %{}) do
    rating
    |> Rating.changeset(attrs)
  end

  def with_average_ratings_for_place(place_id) do
    from(r in Rating,
      where: r.place_id == ^place_id,
      select: %{
        total_ratings: count(r.id),
        trans_friendliness_average: avg(r.trans_friendliness_rating),
        accessibility_rating: avg(r.accessibility_rating),
        overall_average: avg(r.overall_rating),
        employer_average: avg(r.employer_rating)
      }
    )
    |> Repo.one()
  end
end
