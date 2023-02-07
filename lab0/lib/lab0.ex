defmodule Week1 do
  def hello_ptr do
    message = "Hello PTR"
    IO.puts(message)
    message
  end
end

Week1.hello_ptr()

defmodule Week2 do
  def is_prime?(n) when n <= 1, do: :false
  def is_prime?(n) when n in [2, 3], do: :true
  def is_prime?(n) do
    floored_sqrt = round(Float.floor(:math.sqrt(n)))
    !Enum.any?(2..floored_sqrt, fn number -> rem(n, number) == 0 end)
  end

  def cylinder_area(height, radius) do
    area = 2 * :math.pi * radius * (height + radius)
    Float.ceil(area, 4)
  end

  def reverse(list) do
    do_reverse(list, [])
  end

  defp do_reverse([h|t], reversed) do
    do_reverse(t, [h|reversed])
  end

  defp do_reverse([], reversed) do
    reversed
  end

  def unique_sum(list) do
    unique_list = Enum.uniq(list)
    Enum.sum(unique_list)
  end

  def extract_random_number(list, n) do
    shuffled_list = Enum.sort_by(list, fn _ -> :rand.uniform() end)
    Enum.take(shuffled_list, n)
  end

  def first_fibonacci_elements(x) do
    for n <- 0..x - 1, do: fib(n)
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n) when n > 1 do
    fib(n - 1) + fib(n - 2)
  end

  def translate(dictionary, string) do
    words = String.split(string, " ", [trim: true])
    translated_words = Enum.map(words, fn word -> dictionary[String.to_atom(word)] || word end)
    Enum.join(translated_words, " ")
  end

  def smallest_number(a, b, c) do
    numbers = [a, b, c]
    numbers = Enum.sort(numbers)
    first_non_zero = Enum.find(numbers, fn number -> number != 0 end)
    numbers = List.delete(numbers, first_non_zero)
    numbers = [first_non_zero | numbers]
    smallest_num = Enum.join(numbers)
    String.to_integer(smallest_num)
  end

  def rotate_left(list, number) do
    to_rotate = Enum.drop(list, number)
    remaining = Enum.take(list, number)
    to_rotate ++ remaining
  end

  def list_right_angled_triangles do
    max_a = 20
    max_b = 20
    max_c = trunc(:math.sqrt(max_a * max_a + max_b * max_b))
    list = for a <- (1..max_a), b <- (1..max_b), c <- (1..max_c), do: {a, b, c}
    Enum.filter(list, fn {a, b, c} -> check_p_theorem(a, b, c) end)
  end

  defp check_p_theorem(a, b, c) do
    if c * c == a * a + b * b, do: true, else: false
  end
end
