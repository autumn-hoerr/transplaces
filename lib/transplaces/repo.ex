defmodule Transplaces.Repo do
  use Ecto.Repo,
    otp_app: :transplaces,
    adapter: Ecto.Adapters.Postgres
end
