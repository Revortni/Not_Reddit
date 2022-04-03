defmodule NotReddit.Repo do
  use Ecto.Repo,
    otp_app: :not_reddit,
    adapter: Ecto.Adapters.Postgres
end
