defmodule EngagementRationerTaskMediator do
  use GenServer

  def start_link(state) do
    IO.puts("Starting engagement rationer task mediator")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(data, state) do
    engagement_rationer = :"EngagementRationer#{state}"
    if Process.whereis(engagement_rationer) != nil, do: send(engagement_rationer, data)
    state = state + 1
    if state >= 4 do
      {:noreply, 1}
    else
      {:noreply, state}
    end
  end
end
