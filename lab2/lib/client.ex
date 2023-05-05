defmodule MessageBroker.Client do
  def serve(socket) do
    msg =
      with {:ok, data} <- read_line(socket),
      {:ok, command} <- MessageBroker.Command.parse(data),
      do: MessageBroker.Command.run(socket, command)

    write_line(socket, msg)
    serve(socket)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :terminal_handler)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp send_client(socket, text) do
    :gen_tcp.send(socket, "#{text}\r\n")
  end

  def write_line(socket, {:ok, text}) do
    send_client(socket, text)
  end

  def write_line(socket, {:error, :unknown, reason}) do
    send_client(socket, "Unknown #{reason}")
  end

  def write_line(socket, {:error, :unauthorized, action}) do
    send_client(socket, "Unauthorized: As a #{MessageBroker.RoleManager.get_readable_role(socket)} you don't have permission to #{action}.")
  end

  def write_line(socket, {:error, :sub_manager, reason}) do
    case reason do
      :already_subscribed -> send_client(socket, "Already subscribed!")
      :not_subscribed -> send_client(socket, "You are not subscribed!")
      :not_subscribed_publisher -> send_client(socket, "You are not subscribed")
      :publisher_not_found -> send_client(socket, "No publisher found!")
      :already_subscribed_to_publisher -> send_client(socket, "Already subscribed!")
      _ -> write_line(socket, {:error, reason})
    end
  end

  def write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  def write_line(socket, {:error, error}) do
    send_client(socket, "Error #{inspect error}")
    exit(error)
  end

  def assign_role(socket) do
    if MessageBroker.RoleManager.has_role?(socket) == false do
      write_line(socket, {:ok, "Type 'PUBLISHER' or 'SUBSCRIBER'"})

      msg =
        with {:ok, data} <- read_line(socket),
        {:ok, role} <- MessageBroker.RoleManager.check_and_assign(socket, String.trim(data)),
        do: conclude(socket, role)

      write_line(socket, msg)
      case msg do
        {:error, :unknown, _} -> assign_role(socket)
        {:ok, _} -> MessageBroker.Client.serve(socket)
      end
    end
  end

  def conclude(socket, role) do
    case role do
      :consumer ->
        {:ok, "Successfully registered as subscriber."}
      :producer ->
        write_line(socket, {:ok, "Enter your name:"})
        with {:ok, name} <- read_line(socket),
        :ok <- MessageBroker.SubscriptionManager.register_publisher(socket, String.trim(name)),
        do: {:ok, "Successfully registered as publisher."}
    end
  end

end
