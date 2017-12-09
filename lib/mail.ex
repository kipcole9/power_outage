defmodule PowerOutage.Mail do
  def send(to, subject, message) do
    port = Port.open({:spawn, "mail -s #{subject} #{to}"}, [:binary])
    Port.command(port, message)
    Port.close(port)
  end
end