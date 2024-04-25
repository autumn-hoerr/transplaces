defmodule Transplaces.Places do
  @moduledoc """
  Context for places and placetypes

  Future:
  maybe break the placetypes out later
  """
  alias Transplaces.Repo
  alias Transplaces.Places.Place

  def get_place_by_name(name) do
    Place
    |> Repo.get_by(name: name)
  end

  def get_place(id) do
    Place
    |> Repo.get(id)
  end

  def get_place!(id) do
    Place
    |> Repo.get!(id)
  end

  def list_places() do
    Place
    |> Repo.all()
  end

  def create_place(attrs) do
    %Place{}
    |> Place.changeset(attrs)
    |> Repo.insert()
  end

  def update_place(%Place{} = place, attrs) do
    place
    |> Place.changeset(attrs)
    |> Repo.update()
  end

  def delete_place(%Place{} = place) do
    Repo.delete(place)
  end
end
