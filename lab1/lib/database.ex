defmodule Database do
  use GenServer

  def start_link(state) do
    IO.puts("Database starting")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    :ets.new(:tweets, [:ordered_set, :protected, :named_table])
    {:ok, state}
  end

  def handle_call({:save_tweet, tweets}, _from, state) do
    new_state = Enum.reduce(tweets, state, fn tweet, acc ->
      :ets.insert(:tweets, {acc, tweet})
      acc + 1
    end)
    # if rem(new_state, 100) == 0 do
    #   IO.puts("State is now #{new_state}")
    #   print_database()
    # end
    {:reply, :ok, new_state}
  end

  def print_database do
    IO.puts("Database Table")
    table = :ets.tab2list(:tweets)
    Enum.each(table, fn {id, tweet} ->
      IO.puts("Id: #{id} Tweet: #{tweet}")
    end)
  end
end
