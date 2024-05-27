defmodule Transplaces.Ratings.Rating do
  @moduledoc """
  Ratings and reviews
  """
  use Transplaces.Schema

  @type id() :: Ecto.UUID.t()

  schema "ratings" do
    field :trans_friendliness_rating, :integer, default: nil
    field :accessibility_rating, :integer, default: nil
    field :overall_rating, :integer, default: nil
    field :employer_rating, :integer, default: nil

    belongs_to :place, Transplaces.Places.Place
    belongs_to :author, Transplaces.Accounts.User

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
    # TODO: add author
    |> validate_required([:place_id])
  end

  def validate_has_one_of(changeset, fields) do
    num_nil_reviews =
      fields
      |> Enum.map(fn field ->
        get_field(changeset, field, nil)
      end)
      |> Enum.reduce(0, fn rating, acc ->
        case rating do
          nil -> acc + 1
          _ -> acc
        end
      end)

    # they can all be zero, but not all nil
    if num_nil_reviews == Enum.count(fields) do
      add_error(changeset, :trans_friendliness_rating, "At least one rating must be provided")
    else
      changeset
    end
  end
end
