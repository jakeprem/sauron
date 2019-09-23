# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :sauron, SauronWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I/nxrEJGCOEzanrrcscVFsp3q95ZTxbvgYbCo4MLNHtnojMfPiM8xxmGwYnrI4ak",
  render_errors: [view: SauronWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sauron.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "THIS SHOULD BE INJECTED"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
