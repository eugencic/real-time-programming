defmodule Publisher do
  def serve(socket) do
    msg =
      with {:ok, data} <- read_line(socket),
      {:ok, command} <- Commands.parse(data),
      do: Commands.run(socket, command)
    write_line(socket, msg)
    serve(socket)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :publisher)
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
    send_message(socket, "As a publisher, you don't have permission to #{action}.")
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
    write_line(socket, {:ok, "Creating the publisher..."})
    result =
      with publisher_role = "PUBLISHER",
      RoleManager.register_role(socket, publisher_role),
      do: register_publisher(socket)
    write_line(socket, result)
    case result do
      {:error, :unknown, _} -> assign_role(socket)
      {:ok, _} -> Publisher.serve(socket)
    end
  end

  def register_publisher(socket) do
    write_line(socket, {:ok, "Enter the publisher's name: "})
    with {:ok, name} <- read_line(socket),
    :ok <- SubscriptionManager.register_publisher(socket, String.trim(name)),
    do: {:ok, "The publisher was created successfully. Execute the command to publish: "}
    end
end
