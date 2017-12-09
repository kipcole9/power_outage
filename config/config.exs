use Mix.Config

config :logger,
  backends: [{LoggerFileBackend, :log}]

config :logger, :log,
  path: System.get_env("POWER_STATUS_LOG_PATH")
