# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fsm,
  ecto_repos: [Fsm.Repo]

# Configures the endpoint
config :fsm, FsmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1GWe2UfDO3maCMge35oCmbzwviHtzUPOHqDm2Ipwyhkej3JGk1SBV0kDg9CGmZBs",
  render_errors: [view: FsmWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fsm.PubSub,
  live_view: [signing_salt: "lYOfuhTV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
