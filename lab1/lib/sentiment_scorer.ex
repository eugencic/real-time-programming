defmodule SentimentScorer do
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
    tweet_words = String.split(data["message"]["tweet"]["text"], " ", trim: true)
    emotion_values_url = "localhost:4000/emotion_values"
    emotion_values = HTTPoison.get!(emotion_values_url).body
    emotion_values_strings = String.split(emotion_values, ["\n", "\t"]) |> Enum.map(&String.replace(&1, "\r", ""))
    emotion_values_pairs = Enum.chunk_every(emotion_values_strings, 2)
    emotion_values_dict = emotion_values_pairs |> Enum.reduce(%{}, fn [word, score], acc -> Map.put(acc, word, score) end)
    values = Enum.map(tweet_words, fn word ->
      case Map.get(emotion_values_dict, word) do
        nil -> 0
        val -> String.to_integer(val)
      end
    end)
    sum_of_values = Enum.reduce(values, 0, fn x, acc -> x + acc end)
    sentiment_score = sum_of_values / length(values)
    IO.puts("Sentiment score: #{sentiment_score}\n")
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, name}
  end
end
