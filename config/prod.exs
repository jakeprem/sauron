use Mix.Config

config :sauron, SauronWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  server: true,
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
