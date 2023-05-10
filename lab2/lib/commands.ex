defmodule Commands do
  def parse(line) do
    data = String.trim(line)
    parts = String.split(data, "/")
    case parts do
      ["publish" | [topic, message]] -> {:ok, {:publish, String.trim(topic), String.trim(message)}}
      ["subscribe" | [topic]] -> {:ok, {:subscribe_topic, String.trim(topic)}}
      ["subscribe_to" | [name]] -> {:ok, {:subscribe_publisher, String.trim(name)}}
      _ -> {:error, :unknown, "command #{inspect data}."}
    end
  end

  def run(client, {:publish, topic, message}) do
    if RoleManager.check_role(client, :producer) do
      status = SubscriptionManager.publish(client, topic, message)
      case status do
        :ok -> {:ok, "Published the message: #{inspect message} to topic: #{inspect topic}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "publish"}
    end
  end

  def run(client, {:subscribe_topic, topic}) do
    if RoleManager.check_role(client, :consumer) do
      status = SubscriptionManager.subscribe_to_topic(client, topic)
      case status do
        :ok -> {:ok, "Subscribed to topic: #{inspect topic}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "subscribe"}
    end
  end

  def run(client, {:subscribe_publisher, name}) do
    if RoleManager.check_role(client, :consumer) do
      status = SubscriptionManager.subscribe_to_publisher(client, name)
      case status do
        :ok -> {:ok, "Subscribed to publisher: #{inspect name}."}
        _ -> status
      end
    else
      {:error, :unauthorized, "subscribe"}
    end
  end
end
