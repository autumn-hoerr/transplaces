defmodule Transplaces.Repo.Migrations.AddActiveFlagToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active, :boolean, default: true
      add :avatar, :string
    end
  end
end
