defmodule Transplaces.Repo.Migrations.AddUsersBack do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :citext, null: false
      add :name, :string
      add :role, :string, default: "user"
      add :last_login, :utc_datetime
      add :discordId, :string
      add :guild_membership_last_checked, :utc_datetime

      timestamps()
    end

    create index(:users, [:email], unique: true)
    create index(:users, [:discordId], unique: true)
    create index(:users, [:id])
  end
end
