defmodule PowerOutage.Mixfile do
  use Mix.Project

  def project do
    [
      app: :power_outage,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: {PowerOutage, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:logger_file_backend, "~> 0.0.10"}]
  end

  defp escript do
    [main_module: PowerOutage]
  end
end
