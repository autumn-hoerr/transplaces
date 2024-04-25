# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Transplaces.Repo.insert!(%Transplaces.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  "Restaurant",
  "Bar",
  "Cafe",
  "Hotel",
  "Museum",
  "Park",
  "Theater",
  "Store",
  "Other"
]
|> Enum.each(fn name ->
  Transplaces.Places.PlaceTypes.create_place_type(%{name: name})
end)

[
  %{
    name: "The Alchemist",
    address: "435 1st Ave N, Minneapolis, MN 55401",
    googlePlaceId: "ChIJwZQ1QJkys1IR5Z3GvJZv8ZQ",
    description: "A cocktail bar in the North Loop",
    accessibilityOptions: "Wheelchair accessible",
    primaryType: "Bar",
    minorityOwned: true,
    womanOwned: false,
    lgbtqOwned: false
  },
  %{
    name: "The Bachelor Farmer",
    address: "50 2nd Ave N, Minneapolis, MN 55401",
    googlePlaceId: "ChIJwZQ1QJkys1IR5Z3GvJZv8ZQ",
    description: "A farm-to-table restaurant in the North Loop",
    accessibilityOptions: "Wheelchair accessible",
    primaryType: "Restaurant",
    minorityOwned: false,
    womanOwned: false,
    lgbtqOwned: true
  },
  %{
    name: "Spyhouse Coffee",
    address: "945 Broadway St NE, Minneapolis, MN 55413",
    googlePlaceId: "ChIJwZQ1QJkys1IR5Z3GvJZv8ZQ",
    description: "A local coffee shop in Northeast",
    accessibilityOptions: "Wheelchair accessible",
    primaryType: "Cafe",
    minorityOwned: false,
    womanOwned: true,
    lgbtqOwned: false
  }
]
|> Enum.each(fn attrs ->
  Transplaces.Places.create_place(attrs)
end)

p1 = Transplaces.Places.get_place_by_name("The Alchemist")
p2 = Transplaces.Places.get_place_by_name("The Bachelor Farmer")

[
  %{
    trans_friendliness_rating: 5,
    accessibility_rating: 5,
    overall_rating: 5,
    employer_rating: 5,
    place_id: p1.id
  },
  %{
    trans_friendliness_rating: 4,
    accessibility_rating: 4,
    overall_rating: 4,
    employer_rating: 4,
    place_id: p1.id
  },
  %{
    trans_friendliness_rating: 3,
    accessibility_rating: 3,
    overall_rating: 3,
    employer_rating: 3,
    place_id: p2.id
  },
  %{
    trans_friendliness_rating: 2,
    accessibility_rating: 2,
    overall_rating: 2,
    employer_rating: 2,
    place_id: p2.id
  },
  %{
    trans_friendliness_rating: 1,
    accessibility_rating: 1,
    overall_rating: 1,
    employer_rating: 1,
    place_id: p2.id
  }
]
|> Enum.each(fn attrs ->
  Transplaces.Ratings.create_rating(attrs)
end)
