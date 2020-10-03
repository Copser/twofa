defmodule Twofa.Repo do
  use Ecto.Repo,
    otp_app: :twofa,
    adapter: Ecto.Adapters.Postgres
end
