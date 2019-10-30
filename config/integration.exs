use Mix.Config

host =
  case System.get_env("HOST_IP") do
    nil -> "127.0.0.1"
    x -> x
  end

endpoints = [{String.to_atom(host), 9092}]

config :logger,
  level: :info

config :sauron, :brook,
  instance: :sauron,
  driver: [
    module: Brook.Driver.Kafka,
    init_arg: [
      endpoints: endpoints,
      topic: "event-stream",
      group: "sauron-events",
      config: [
        begin_offset: :earliest
      ]
    ]
  ],
  handlers: [Sauron.EventHandler],
  storage: [
    module: Brook.Storage.Redis,
    init_arg: [
      redix_args: [host: host],
      namespace: "sauron:view"
    ]
  ]
