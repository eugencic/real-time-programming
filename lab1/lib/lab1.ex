defmodule Lab1 do
  def start do
    IO.puts("Starting application")
    MainSupervisor.start_link
  end
end
