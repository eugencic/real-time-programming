defmodule Reader do
  use GenServer

  def start_link(url) do
    IO.puts("Starting stream reader")
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    IO.puts "Connecting"
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: ""}, url) do
    HTTPoison.get!(url, [], recv_timeout: :infinity, stream_to: self())
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: "event: \"message\"\n\ndata: {\"message\": panic}\n\n"}, url) do
    send(TaskMediator, :kill)
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, url) do
    [_, data] = Regex.run(~r/data: ({.+})\n\n$/, chunk)
    case Poison.decode(data) do
      {:ok, result} -> send(TaskMediator, result)
      {:error, _} -> nil
    end
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, url) do
    IO.puts "Status: #{inspect status}"
    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, url) do
    IO.puts "Headers: #{inspect headers}"
    {:noreply, url}
  end

  def handle_info(_, url) do
    {:noreply, url}
  end
end
