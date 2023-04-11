defmodule Redactor do
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
    # IO.puts("Received tweet: #{censored_tweet}\n")
    send(Batcher, censored_tweet)
    min = 5
    max = 50
    lambda = Enum.sum(min..max) / Enum.count(min..max)
    Process.sleep(trunc(Statistics.Distributions.Poisson.rand(lambda)))
    {:noreply, name}
  end
end
