defmodule RedactorPool do
  use Supervisor

  def start_link(state) do
    IO.puts("Starting redactor pool")
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: :Redactor1,
        start: {Redactor, :start_link, [:Redactor1]},
        restart: :permanent
      },
      %{
        id: :Redactor2,
        start: {Redactor, :start_link, [:Redactor2]},
        restart: :permanent
      },
      %{
        id: :Redactor3,
        start: {Redactor, :start_link, [:Redactor3]},
        restart: :permanent
      },
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
