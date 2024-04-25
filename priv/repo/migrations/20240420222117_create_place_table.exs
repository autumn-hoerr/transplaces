defmodule Transplaces.Repo.Migrations.CreatePlaceTable do
  use Ecto.Migration

  def change do
    create table(:places, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :address, :string
      add :googlePlaceId, :string
      add :description, :string
      add :accessibilityOptions, :string
      add :primaryType, :string
      add :minorityOwned, :boolean
      add :womanOwned, :boolean
      add :lgbtqOwned, :boolean

      timestamps()
    end

    create table(:place_types, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    create table(:places_place_types, primary_key: false) do
      add :place_id, references(:places, on_delete: :delete_all, type: :uuid), primary_key: true

      add :place_type_id, references(:place_types, on_delete: :delete_all, type: :uuid),
        primary_key: true
    end

    create unique_index(:place_types, [:name])
    create index(:places_place_types, [:place_id])
    create index(:places_place_types, [:place_type_id])
  end
end
