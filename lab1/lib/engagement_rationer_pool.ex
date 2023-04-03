defmodule EngagementRationerPool do
  use Supervisor

  def start_link(state) do
    IO.puts("Starting engagement rationer pool")
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: :EngagementRationer1,
        start: {EngagementRationer, :start_link, [:EngagementRationer1]},
        restart: :permanent
      },
      %{
        id: :EngagementRationer2,
        start: {EngagementRationer, :start_link, [:EngagementRationer2]},
        restart: :permanent
      },
      %{
        id: :EngagementRationer3,
        start: {EngagementRationer, :start_link, [:EngagementRationer3]},
        restart: :permanent
      },
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
