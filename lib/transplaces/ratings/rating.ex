defmodule Transplaces.Ratings.Rating do
  @moduledoc """
  Ratings and reviews
  """
  use Transplaces.Schema

  @type id() :: Ecto.UUID.t()

  schema "ratings" do
    field :trans_friendliness_rating, :integer, default: 0
    field :accessibility_rating, :integer, default: 0
    field :overall_rating, :integer, default: 0
    field :employer_rating, :integer, default: 0

    belongs_to :place, Transplaces.Places.Place
    belongs_to :author, Transplaces.Users.User

    timestamps()
  end

  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [
      :trans_friendliness_rating,
      :accessibility_rating,
      :overall_rating,
      :employer_rating,
      :place_id
    ])
    |> validate_has_one_of([
      :trans_friendliness_rating,
      :accessibility_rating,
      :overall_rating,
      :employer_rating
    ])
  end

  def validate_has_one_of(changeset, fields) do
    review_total =
      fields
      |> Enum.map(fn field ->
        get_field(changeset, field, 0)
      end)
      |> Enum.sum()

    if review_total == 0 do
      add_error(changeset, :trans_friendliness_rating, "At least one rating must be provided")
    else
      changeset
    end
  end
end
