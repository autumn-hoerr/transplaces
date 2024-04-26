defmodule Transplaces.Repo.Migrations.DropUsersTableForNow do
  use Ecto.Migration

  def change do
    # it was made in a mix gen task and isn't what I meant to do
    drop table(:users_tokens)
    drop table(:users)
  end
end
