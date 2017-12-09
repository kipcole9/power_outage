defmodule PowerOutage do
  @moduledoc """
  Documentation for PowerOutage.
  """

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info "Starting power outage logging"

    {:ok, source, percent} = PowerOutage.Status.power_status
    Logger.info "Power source is #{inspect source}. Battery is at #{percent}%"

    children = [supervisor(PowerOutage.Supervisor, [])]
    opts = [strategy: :one_for_one, name: __MODULE__]

    Supervisor.start_link(children, opts)
  end

  def main(_args \\ []) do
    Process.flag(:trap_exit, true)

    receive do
      {:EXIT, _from, _reason} -> main()
    end
  end
end
