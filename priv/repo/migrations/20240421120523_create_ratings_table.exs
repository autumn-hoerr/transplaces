defmodule Transplaces.Repo.Migrations.CreateRatingsTable do
  use Ecto.Migration

  def change do
    create table(:ratings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :trans_friendliness_rating, :integer
      add :accessibility_rating, :integer
      add :overall_rating, :integer
      add :employer_rating, :integer
      add :place_id, references(:places, on_delete: :nothing, type: :binary_id)
      timestamps()
    end
  end
end
