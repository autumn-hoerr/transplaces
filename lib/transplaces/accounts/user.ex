defmodule Transplaces.Accounts.User do
  @moduledoc """
  Users and authentication
  """
  use Transplaces.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :role, :string, default: "user"
    field :last_login, :utc_datetime
    field :discordId, :string
    field :guild_membership_last_checked, :utc_datetime

    timestamps()

    has_many :ratings, Transplaces.Ratings.Rating, foreign_key: :author_id
    # has_many :comments, Transplaces.Comments.Comment
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :name,
      :role,
      :last_login,
      :discordId,
      :guild_membership_last_checked
    ])
    |> validate_required([:email, :name, :discordId, :guild_membership_last_checked])
    |> unique_constraint(:email)
    |> unique_constraint(:discordId)
  end
end
