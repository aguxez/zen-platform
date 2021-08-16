defmodule Zen.Repo do
  use Ecto.Repo,
    otp_app: :zen,
    adapter: Ecto.Adapters.Postgres
end
