defmodule HelloPTR do
  def hello_ptr do
    IO.puts("Hello PTR")
    :message
  end
end

defmodule IsPrime do
  def is_prime?(n) when n <= 1, do: false
  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(n) do
    floored_sqrt = round(Float.floor(:math.sqrt(n)))
    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end
end

defmodule CylinderArea do
  def cylinder_area(radius, height) do
    2 * :math.pi * radius * (height + radius)
  end
end

defmodule Reverse do
  def reverse(list) do
    Enum.reverse(list)
  end
end

defmodule UniqueSum do
  def unique_sum(list) do
    unique_list = Enum.uniq(list)
    Enum.sum(unique_list)
  end
end

defmodule RandomNumber do
  def random_number(list, n) do
    shuffled_list = Enum.sort_by(list, fn _ -> :rand.uniform() end)
    Enum.take(shuffled_list, n)
  end
end

defmodule Fibonacci do
  def fibonacci(x) do
    for n <- 0..x - 1, do: fib(n)
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n) when n > 1 do
    fib(n - 1) + fib(n - 2)
  end
end

defmodule Translate do
  def translate(dictionary, string) do
    words = String.split(string, " ")
    translated_words = Enum.map(words, fn word -> translate_word(dictionary, word) end)
    translated_words = Enum.join(translated_words, " ")
    IO.puts(translated_words)
  end

  defp translate_word(dictionary, word) do
    trimmed_word = String.trim(word)
    dictionary[trimmed_word] || word
  end
end

HelloPTR.hello_ptr()
