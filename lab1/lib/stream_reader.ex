defmodule Reader do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    IO.puts "Connecting to stream..."
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: ""}, url) do
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state) do
    [_, data] = Regex.run(~r/data: ({.+})\n\n$/, chunk)
    case Poison.decode(data) do
      {:ok, result} -> send(Printer, result)
      {:error, _} -> nil
    end
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, state) do
    IO.puts "Connection status: #{inspect status}"
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, state) do
    IO.puts "Connection headers: #{inspect headers}"
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
