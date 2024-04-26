defmodule Transplaces.Repo.Migrations.AddUsersToRatings do
  use Ecto.Migration

  def change do
    # we'll need to come back and add the references() bit later once users exist again
    alter table(:ratings) do
      add :author_id, :integer
    end
  end
end
