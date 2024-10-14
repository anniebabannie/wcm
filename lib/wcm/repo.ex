defmodule Wcm.Repo do
  use Ecto.Repo,
    otp_app: :wcm,
    adapter: Ecto.Adapters.Postgres
end
