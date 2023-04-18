defmodule Batcher do
  use GenServer

  def start_link({state, batch_size, timeout}) do
    IO.puts("Starting batcher")
    GenServer.start_link(__MODULE__, {state, batch_size, timeout}, name: __MODULE__)
  end

  def init({state, batch_size, timeout}) do
    Process.register(spawn_link(fn -> loop(timeout) end), :checker)
    {:ok, {state, batch_size}}
  end

  def handle_call(:get_state, _, state) do
    {:reply, state, state}
  end

  def handle_info(:set_state, {batch_size}) do
    {:noreply, {[], batch_size}}
  end

  def handle_info(tweet, {state, batch_size}) do
    new_state = state ++ [tweet]
    case length(new_state) == batch_size do
      true ->
        send(:checker, {:batch_full, new_state})
        {:noreply, {[], batch_size}}
      false ->
        {:noreply, {new_state, batch_size}}
    end
  end

  def loop(timeout) do
    receive do
      {:batch_full, state} ->
        IO.puts("Batcher is full. Printing the data...\n")
        print_tweets(state)
        save_tweets(state)
        loop(timeout)
    after
      timeout ->
        state = GenServer.call(Batcher, :get_state)
        send(Batcher, :set_state)
        IO.puts("Timeout reached. Printing the data...\n")
        print_tweets(state)
        loop(timeout)
    end
  end

  def print_tweets(tweets) do
    Enum.each(tweets, fn tweet -> IO.puts("Received tweet: #{tweet}\n") end)
  end

  def save_tweets(tweets) do
    GenServer.call(Database, {:save_tweet, tweets})
  end
end
