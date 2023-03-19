defmodule Printer do
  use GenServer

  def start_link(name) do
    IO.puts("Starting #{name}")
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    {:ok, name}
  end

  def handle_info(:kill, name) do
    IO.puts("Killing #{name}")
    exit(:kill)
    {:noreply, name}
  end

  def handle_info(data, name) do
    IO.puts("Received tweet: #{data["message"]["tweet"]["text"]} \n")
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, name}
  end
end
