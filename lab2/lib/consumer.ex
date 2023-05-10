defmodule Consumer do
  def serve(socket) do
    msg =
      with {:ok, data} <- read_line(socket),
      {:ok, command} <- Commands.parse(data),
      do: Commands.run(socket, command)
    write_line(socket, msg)
    serve(socket)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :consumer)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp send_message(socket, text) do
    :gen_tcp.send(socket, "#{text}\r\n")
  end

  def write_line(socket, {:ok, text}) do
    send_message(socket, text)
  end

  def write_line(socket, {:error, :unauthorized, action}) do
    send_message(socket, "As a consumer, you don't have permission to #{action}.")
  end

  def write_line(socket, {:error, :sub_manager, reason}) do
    case reason do
      :already_subscribed -> send_message(socket, "Already subscribed to this topic!")
      :already_subscribed_to_publisher -> send_message(socket, "Already subscribed to this publisher!")
      :publisher_not_found -> send_message(socket, "No publisher found!")
      _ -> write_line(socket, {:error, reason})
    end
  end

  def write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  def write_line(socket, {:error, :unknown, reason}) do
    send_message(socket, "Unknown #{reason}")
  end

  def write_line(socket, {:error, error}) do
    send_message(socket, "Error #{inspect error}")
    exit(error)
  end

  def assign_role(socket) do
    write_line(socket, {:ok, "Creating the consumer..."})
    result =
      with consumer_role = "CONSUMER",
      RoleManager.register_role(socket, consumer_role),
      do: {:ok, "The consumer was created successfully. Execute a command to subscribe: "}
    write_line(socket, result)
    case result do
      {:error, :unknown, _} -> assign_role(socket)
      {:ok, _} -> Consumer.serve(socket)
    end
  end
end
