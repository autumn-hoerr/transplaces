defmodule Transplaces.Places.PlaceTypes do
  @moduledoc """
  Context for place types
  """
  import Ecto.Query
  alias Ecto.Multi
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

  def ids_from_names(names) do
    from(pt in PlaceType, where: pt.name in ^names)
    |> select([pt], pt.id)
    |> Repo.all()
  end

  def get_all_places_of_type(query \\ PlaceType, type) do
    query
    |> preload(:places)
    |> where([pt], pt.name == ^type)
    |> Repo.one()
  end

  def create_placetype_changeset(placetype \\ %PlaceType{}, attrs) do
    placetype
    |> PlaceType.changeset(attrs)
  end

  def create_place_type(attrs) do
    %PlaceType{}
    |> PlaceType.changeset(attrs)
    |> Repo.insert()
  end

  def create_place_types(list) when is_list(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {place_type, index}, multi ->
      Multi.insert(
        multi,
        {:place_type, index},
        create_placetype_changeset(%{name: place_type, places_list: []}),
        on_conflict: :nothing
      )
    end)
  end

  def create_place_types(list) when is_binary(list),
    do: create_place_type(%{name: list, places_list: []})

  def update_place_type(%PlaceType{} = place_type, attrs) do
    place_type
    |> PlaceType.changeset(attrs)
    |> Repo.update()
  end

  def delete_place_type(%PlaceType{} = place_type) do
    Repo.delete(place_type)
  end
end
