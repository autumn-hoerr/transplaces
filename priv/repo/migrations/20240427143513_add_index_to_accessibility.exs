defmodule Transplaces.Repo.Migrations.AddIndexToAccessibility do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX places_accessibility_opts ON places USING GIN(accessibility_opts)")
  end

  def down do
    execute("DROP INDEX places_accessibility_opts")
  end
end
