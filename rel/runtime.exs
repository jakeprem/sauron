use Mix.Config

kafka_brokers = System.get_env("KAFKA_BROKERS")
redis_host = System.get_env("REDIS_HOST")
log_level = System.get_env("LOG_LEVEL", "warn") |> String.to_atom()

if kafka_brokers do
  endpoints =
    kafka_brokers
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn entry -> String.split(entry, ":") end)
    |> Enum.map(fn [host, port] -> {String.to_atom(host), String.to_integer(port)} end)

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
    module: Brook.Storage.Ets,
    init_arg: [
      # redix_args: [host: redis_host],
      namespace: "waterwheel:view"
    ]
  ]
end

config :logger,
  level: log_level


