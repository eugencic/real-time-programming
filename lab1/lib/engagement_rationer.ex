defmodule EngagementRationer do
  use GenServer

  def start_link(name) do
    IO.puts("Starting #{name}")
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    {:ok, name}
  end

  def handle_info(:kill, name) do
    IO.puts("Killing #{name}")
    exit(:kill)
    {:noreply, name}
  end

  def handle_info(data, name) do
    favorite_count = data["message"]["tweet"]["retweeted_status"]["favorite_count"] || 0
    retweet_count = data["message"]["tweet"]["retweeted_status"]["retweet_count"] || 0
    followers_count = data["message"]["tweet"]["user"]["followers_count"]
    engagement_ratio =
      if followers_count == 0,
        do: 0,
        else: (favorite_count + retweet_count) / followers_count
    IO.puts("Engagement ratio: #{engagement_ratio}\n")
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, name}
  end
end
