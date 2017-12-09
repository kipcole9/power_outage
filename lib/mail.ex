defmodule PowerOutage.Mail do
  def send(to, subject, message) do
    to = String.split(to, ~r/[, ]+/)
    path = System.find_executable("mail")
    port = Port.open({:spawn_executable, path}, [:binary, args: ["-s", subject] ++ to])
    Port.command(port, message)
    Port.close(port)
  end
end