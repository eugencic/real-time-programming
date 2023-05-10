defmodule RoleManager do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :role_manager)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def assign_role(client, role) do
    GenServer.call(:role_manager, {:assign_role, client, role})
  end

  def get_role(client) do
    GenServer.call(:role_manager, {:get_role, client})
  end
  
  def register_role(client, input) do
    status = case input do
      "PUBLISHER" -> assign_role(client, :producer)
      "CONSUMER" -> assign_role(client, :consumer)
    end
    status
  end

  def check_role(client, required_role) do
    role = get_role(client)
    role == required_role
  end

  def handle_call({:assign_role, client, role}, _from, state) do
    new_state = Map.put(state, client, role)
    {:reply, {:ok, role}, new_state}
  end

  def handle_call({:get_role, client}, _from, state) do
    role = Map.get(state, client, :no_role)
    {:reply, role, state}
  end
end
