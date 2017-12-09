defmodule PowerOutage.Worker do
  @moduledoc """

  """

  use GenServer
  require Logger
  alias PowerOutage.Mail

  @retrieval_interval_in_minutes 0.5
  @retrieve_every trunc(@retrieval_interval_in_minutes * 60_000)
  @send_to System.get_env("POWER_OUTAGE_SEND_TO")

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    schedule_work()
    {:ok, source, _percent} = PowerOutage.Status.power_status
    Mail.send(@send_to, "Refuge_Power_Startup", "Source is #{inspect source}")
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
    message = "Power changed from #{inspect from} to #{inspect to}. Battery is at #{percent}%"
    Logger.warn message

    case to do
      :battery ->
        Mail.send(@send_to, "Refuge_Power_Outage", message)
      :ac_power ->
        Mail.send(@send_to, "Refuge_Power_Restored", message)
    end
  end

end