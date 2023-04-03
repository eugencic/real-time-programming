defmodule SentimentScorerTaskMediator do
  use GenServer

  def start_link(state) do
    IO.puts("Starting sentiment scorer task mediator")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(data, state) do
    sentiment_scorer = :"SentimentScorer#{state}"
    if Process.whereis(sentiment_scorer) != nil, do: send(sentiment_scorer, data)
    state = state + 1
    if state >= 4 do
      {:noreply, 1}
    else
      {:noreply, state}
    end
  end
end
