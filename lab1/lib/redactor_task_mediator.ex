defmodule RedactorTaskMediator do
  use GenServer

  def start_link(state) do
    IO.puts("Starting redactor task mediator")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(data, state) do
    redactor = :"Redactor#{state}"
    if Process.whereis(redactor) != nil, do: send(redactor, data)
    state = state + 1
    if state >= 4 do
      {:noreply, 1}
    else
      {:noreply, state}
    end
  end
end
