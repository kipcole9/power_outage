defmodule PowerOutage.Supervisor do
  @moduledoc false

  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(PowerOutage.Worker, [PowerOutage.Worker])
    ]

    supervise(children, strategy: :one_for_one)
  end
end