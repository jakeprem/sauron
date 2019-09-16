use Mix.Config

config :waterwheel, WaterwheelWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

host =
  case System.get_env("HOST_IP") do
    nil -> "127.0.0.1"
    x -> x
  end

endpoints = [{String.to_atom(host), 9092}]

config :waterwheel, :brook,
  driver: [
    module: Brook.Driver.Kafka,
    init_arg: [
      endpoints: endpoints,
      topic: "event-stream",
      group: "waterwheel-events",
      config: [
        begin_offset: :earliest
      ]
    ]
  ],
  handlers: [Waterwheel.EventHandler],
  storage: [
    module: Brook.Storage.Redis,
    init_arg: [
      redix_args: [host: host],
      namespace: "waterwheel:view"
    ]
  ]

config :waterwheel, WaterwheelWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/waterwheel_web/views/.*(ex)$},
      ~r{lib/waterwheel_web/templates/.*(eex)$},
      ~r{lib/waterwheel_web/live/.*(ex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
