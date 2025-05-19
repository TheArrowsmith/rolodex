defmodule Rolodex.Repo do
  use Ecto.Repo,
    otp_app: :rolodex,
    adapter: Ecto.Adapters.Postgres
end
