defmodule Printer do
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
    {:ok, bad_words_json} = File.read("./lib/bad_words.json")
    {:ok, bad_words_dict} = Poison.decode(bad_words_json)
    bad_words = bad_words_dict["BadWords"]
    tweet_words = String.split(data["message"]["tweet"]["text"], " ", trim: true)
    censored_words = Enum.map(tweet_words, fn word ->
      word_lowercase = String.downcase(word)
      if Enum.member?(bad_words, word_lowercase) do
        String.duplicate("*", String.length(word))
      else
        word
      end
    end)
    censored_tweet = Enum.join(censored_words, " ")
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
    favorite_count = data["message"]["tweet"]["retweeted_status"]["favorite_count"] || 0
    retweet_count = data["message"]["tweet"]["retweeted_status"]["retweet_count"] || 0
    followers_count = data["message"]["tweet"]["user"]["followers_count"]
    engagement_ratio =
      if followers_count == 0,
        do: 0,
        else: (favorite_count + retweet_count) / followers_count
    IO.puts("Received tweet: #{censored_tweet}\nSentiment score: #{sentiment_score}\nEngagement ratio: #{engagement_ratio}\n")
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, name}
  end
end
