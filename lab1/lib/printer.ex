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
    {:noreply, state}
  end
end
