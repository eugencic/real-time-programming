defmodule MessageBroker.Command do
  def parse(line) do
    data = String.trim(line)
    parts = String.split(data, "|")

    case parts do
      ["PUBLISH" | [topic, message]] -> {:ok, {:publish, String.trim(topic), String.trim(message)}}
      ["SUBSCRIBE" | [topic]] -> {:ok, {:subscribe_topic, String.trim(topic)}}
      ["SUBSCRIBE_TO" | [name]] -> {:ok, {:subscribe_publisher, String.trim(name)}}
      ["UNSUBSCRIBE" | [topic]] -> {:ok, {:unsubscribe, String.trim(topic)}}
      ["UNSUBSCRIBE_FROM" | [name]] -> {:ok, {:unsubscribe_publisher, String.trim(name)}}
      _ -> {:error, :unknown, "command #{inspect data}."}
    end
  end

  def run(client, {:subscribe_topic, topic}) do
    if MessageBroker.RoleManager.check_role(client, :consumer) do
      status = MessageBroker.SubscriptionManager.subscribe_to_topic(client, topic)

      case status do
        :ok -> {:ok, "Subscribed to topic: #{inspect topic}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "subscribe"}
    end
  end

  def run(client, {:subscribe_publisher, name}) do
    if MessageBroker.RoleManager.check_role(client, :consumer) do
      status = MessageBroker.SubscriptionManager.subscribe_to_publisher(client, name)

      case status do
        :ok -> {:ok, "Subscribed to publisher: #{inspect name}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "subscribe"}
    end
  end

  def run(client, {:unsubscribe, topic}) do
    if MessageBroker.RoleManager.check_role(client, :consumer) do
      status = MessageBroker.SubscriptionManager.unsubscribe(client, topic)

      case status do
        :ok -> {:ok, "Unsubscribed from topic: #{inspect topic}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "unsubscribe"}
    end
  end

  def run(client, {:unsubscribe_publisher, name}) do
    if MessageBroker.RoleManager.check_role(client, :consumer) do
      status = MessageBroker.SubscriptionManager.unsubscribe_from_publisher(client, name)

      case status do
        :ok -> {:ok, "Unsubscribed from publisher: #{inspect name}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "unsubscribe"}
    end
  end

  def run(client, {:publish, topic, message}) do
    if MessageBroker.RoleManager.check_role(client, :producer) do
      status = MessageBroker.SubscriptionManager.publish(client, topic, message)

      case status do
        :ok -> {:ok, "Published to topic: #{inspect topic} the message: #{inspect message}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "publish"}
    end
  end
end
