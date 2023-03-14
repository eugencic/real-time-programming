defmodule Reader do
  use GenServer

  def start(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    IO.puts "Connecting..."
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: ""}, url) do
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: data}, state) do
  [_, json] = Regex.run(~r/data: ({.+})\n\n$/, data)

    case Poison.decode(json) do
      {:ok, result} -> send(Printer, result)
      {:error, _} -> nil
    end

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
