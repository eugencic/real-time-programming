defmodule MessageBroker do
  use Application

  def start(_type, _args) do
    publisher_port = String.to_integer(System.get_env("PUBLISHER_PORT") || "4080")
    consumer_port = String.to_integer(System.get_env("CONSUMER_PORT") || "4081")
    children = [
      {Task.Supervisor, name: TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Publisher.Server.accept(publisher_port) end}, restart: :permanent, id: :publisher_server),
      Supervisor.child_spec({Task, fn -> Consumer.Server.accept(consumer_port) end}, restart: :permanent, id: :consumer_server),
      RoleManager,
      SubscriptionManager,
    ]
    opts = [strategy: :one_for_one, name: MessageBroker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
