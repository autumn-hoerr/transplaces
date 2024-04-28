defmodule Transplaces.Repo.Migrations.AddNameAddressIndexToPlace do
  use Ecto.Migration

  def change do
    create index(:places, [:name, :address], unique: true)
  end
end
