defmodule MainSupervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting main supervisor")
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Batcher, {[], 10, 1000}},
      {RedactorPool, :start_link},
      {RedactorTaskMediator, 1},
      {SentimentScorerPool, :start_link},
      {SentimentScorerTaskMediator, 1},
      {EngagementRationerPool, :start_link},
      {EngagementRationerTaskMediator, 1},
      %{
        id: :Reader1,
        start: {Reader, :start_link, ["localhost:4000/tweets/1"]}
      },
      %{
        id: :Reader2,
        start: {Reader, :start_link, ["localhost:4000/tweets/2"]}
      }
    ]
    Supervisor.init(children, strategy: :rest_for_one)
  end
end
