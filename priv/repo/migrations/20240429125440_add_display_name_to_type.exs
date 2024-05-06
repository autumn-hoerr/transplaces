defmodule Transplaces.Repo.Migrations.AddDisplayNameToType do
  use Ecto.Migration

  def change do
    alter table(:place_types) do
      add :display_name, :string
    end

    rename table("places"), :primaryType, to: :primary_type
  end
end
