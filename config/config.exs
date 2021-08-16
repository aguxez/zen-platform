# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tesla, adapter: Tesla.Adapter.Gun

config :zen,
  ecto_repos: [Zen.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :zen, ZenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7qUbKDATSqmpyV9j4EZeBFrXPDdMKjzXRlEcul+gp0tWduo14QbIObyFwL24/xKF",
  render_errors: [view: ZenWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Zen.PubSub,
  live_view: [signing_salt: "Wtb7YPxo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
