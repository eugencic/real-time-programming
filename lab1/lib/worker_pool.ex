defmodule WorkerPool do
  use Supervisor

  def start_link(state) do
    IO.puts("Starting worker pool")
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: :Printer1,
        start: {Printer, :start_link, [:Printer1]},
        restart: :permanent
      },
      %{
        id: :Printer2,
        start: {Printer, :start_link, [:Printer2]},
        restart: :permanent
      },
      %{
        id: :Printer3,
        start: {Printer, :start_link, [:Printer3]},
        restart: :permanent
      },
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
