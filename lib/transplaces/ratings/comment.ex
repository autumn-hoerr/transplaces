defmodule Transplaces.Ratings.Comment do
  @moduledoc """
  Comments on ratings
  """
  use Transplaces.Schema

  @type id() :: Ecto.UUID.t()

  schema "comments" do
    field :body, :string

    belongs_to :rating, Transplaces.Ratings.Rating
    belongs_to :author, Transplaces.Users.User
    belongs_to :place, Transplaces.Places.Place

    timestamps()
  end
end
