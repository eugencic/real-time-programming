defmodule SentimentScorerPool do
  use Supervisor

  def start_link(state) do
    IO.puts("Starting sentiment scorer pool")
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: :SentimentScorer1,
        start: {SentimentScorer, :start_link, [:SentimentScorer1]},
        restart: :permanent
      },
      %{
        id: :SentimentScorer2,
        start: {SentimentScorer, :start_link, [:SentimentScorer2]},
        restart: :permanent
      },
      %{
        id: :SentimentScorer3,
        start: {SentimentScorer, :start_link, [:SentimentScorer3]},
        restart: :permanent
      },
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
