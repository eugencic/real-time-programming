defmodule ReaderSupervisor do
  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    children = [
      {Printer, :ok},
      %{
        id: :reader1,
        start: {Reader, :start, ["localhost:4000/tweets/1"]}
      },
      %{
        id: :reader2,
        start: {Reader, :start, ["localhost:4000/tweets/2"]}
      }
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
