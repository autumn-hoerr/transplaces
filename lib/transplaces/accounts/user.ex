defmodule Transplaces.Accounts.User do
  @moduledoc """
  Users and authentication
  """
  use Transplaces.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :role, :string, default: "user"
    field :confirmed_at, :utc_datetime

    timestamps()

    # has_many :ratings, Transplaces.Ratings.Rating
    # has_many :comments, Transplaces.Comments.Comment
  end
end
