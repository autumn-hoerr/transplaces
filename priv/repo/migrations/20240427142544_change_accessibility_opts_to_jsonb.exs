defmodule Transplaces.Repo.Migrations.ChangeAccessibilityOptsToJsonb do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :accessibility_opts, :map, null: false, default: %{}
      remove :accessibilityOptions, :string
    end
  end
end
