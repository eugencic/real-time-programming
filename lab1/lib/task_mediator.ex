defmodule TaskMediator do
  use GenServer

  def start_link(state) do
    IO.puts("Starting task mediator")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(data, state) do
    printer = :"Printer#{state}"
    send(printer, data)
    state = state + 1
    if state >= 4 do
      {:noreply, 1}
    else
      {:noreply, state}
    end
  end
end
