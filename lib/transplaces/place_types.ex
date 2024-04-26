defmodule Transplaces.Places.PlaceTypes do
  @moduledoc """
  Context for place types
  """
  import Ecto.Query
  alias Transplaces.Repo
  alias Transplaces.Places.PlaceType

  def list_place_types do
    PlaceType
    |> Repo.all()
  end

  def get_place_type(id) do
    PlaceType
    |> Repo.get(id)
  end

  def get_place_types(ids) do
    from(pt in PlaceType, where: pt.id in ^ids)
    |> Repo.all()
  end

  def get_all_places_of_type(query \\ PlaceType, type) do
    query
    |> preload(:places)
    |> where([pt], pt.name == ^type)
    |> Repo.one()
  end

  def create_place_type(attrs) do
    %PlaceType{}
    |> PlaceType.changeset(attrs)
    |> Repo.insert()
  end

  def update_place_type(%PlaceType{} = place_type, attrs) do
    place_type
    |> PlaceType.changeset(attrs)
    |> Repo.update()
  end

  def delete_place_type(%PlaceType{} = place_type) do
    Repo.delete(place_type)
  end
end
