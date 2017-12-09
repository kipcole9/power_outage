defmodule PowerOutage.Worker do
  @moduledoc """

  """

  use GenServer
  require Logger

  @retrieval_interval_in_minutes 0.5
  @retrieve_every trunc(@retrieval_interval_in_minutes * 60_000)

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    schedule_work()
    {:ok, source, _percent} = PowerOutage.Status.power_status
    {:ok, source}
  end

  def handle_info(:check_power_status, state) do
    {:ok, source, percent} = PowerOutage.Status.power_status
    if source != state do
      notify(state, source, percent)
    end

    schedule_work()
    {:noreply, source}
  end

  defp schedule_work do
    Process.send_after(self(), :check_power_status, @retrieve_every)
  end

  defp notify(from, to, percent) do
    Logger.warn "Power changed from #{inspect from} to #{inspect to}. Battery is at #{percent}%"
  end

end