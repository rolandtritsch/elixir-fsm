defmodule Fsm.Repo do
  use Ecto.Repo,
    otp_app: :fsm,
    adapter: Ecto.Adapters.Postgres
end
