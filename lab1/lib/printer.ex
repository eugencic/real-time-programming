defmodule Printer do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(data, state) do
    IO.puts("Received tweet: #{data["message"]["tweet"]["text"]} \n")
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, state}
  end
end
