defmodule Transplaces.Connectors.Epicenters do
  @moduledoc """
  lat/long for places we want to save
  """
  @ilm_lat 34.2071359
  @ilm_long -77.87207

  @topsail_lat 34.3768986
  @topsail_long -77.653721

  @hollyridge_lat 34.50231
  @hollyridge_long -77.5477

  @camp_lejeune_lat 34.583605
  @camp_lejeune_long -77.3706

  @jacksonville_lat 34.7268707
  @jacksonville_long -77.47627

  @swansboro_lat 34.6943455
  @swansboro_long -77.166207

  @morehead_city_lat 34.7277117
  @morehead_city_long -76.7992125

  @new_bern_lat 35.077906
  @new_bern_long -77.1574926

  def ilm() do
    %{
      latitude: @ilm_lat,
      longitude: @ilm_long
    }
  end

  def topsail() do
    %{
      latitude: @topsail_lat,
      longitude: @topsail_long
    }
  end

  def hollyridge() do
    %{
      latitude: @hollyridge_lat,
      longitude: @hollyridge_long
    }
  end

  def camp_lejeune() do
    %{
      latitude: @camp_lejeune_lat,
      longitude: @camp_lejeune_long
    }
  end

  def jacksonville() do
    %{
      latitude: @jacksonville_lat,
      longitude: @jacksonville_long
    }
  end

  def swansboro() do
    %{
      latitude: @swansboro_lat,
      longitude: @swansboro_long
    }
  end

  def morehead_city() do
    %{
      latitude: @morehead_city_lat,
      longitude: @morehead_city_long
    }
  end

  def new_bern() do
    %{
      latitude: @new_bern_lat,
      longitude: @new_bern_long
    }
  end

  def locations() do
    [
      ilm(),
      # topsail(),
      # hollyridge(),
      # camp_lejeune(),
      # jacksonville(),
      # swansboro(),
      # morehead_city(),
      # new_bern()
    ]
  end
end
