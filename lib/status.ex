defmodule PowerOutage.Status do
  require Logger

  def power_status do
    System.cmd("pmset", ["-g", "batt"])
    |> extract_status
  end

  @pattern Regex.compile!("Now drawing from '(?<source>.*)'.*\t(?<percent>[0-9]+)%", [:dotall])
  defp extract_status({status, 0}) do
    Regex.named_captures(@pattern, status)
    |> codify_source
  end

  defp extract_status({message, exit_code}) do
    Logger.error "Could not retrieve power status.  " <>
    "Exit code #{inspect exit_code} and message #{inspect message}"

    {:error, {exit_code, message}}
  end

  defp codify_source(%{"source" => "AC Power", "percent" => percentage}) do
    {:ok, :ac_power, String.to_integer(percentage)}
  end

  defp codify_source(%{"source" => "Battery Power", "percent" => percentage}) do
    {:ok, :battery, String.to_integer(percentage)}
  end

  defp codify_source(source) do
    {:unknown, inspect(source)}
  end
end

