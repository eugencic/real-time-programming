# Laboratory Work Nr.0

## Week 1

These are the tasks for the first week.

## Installation

### Clone the repository

```bash
 git clone https://github.com/eugencic/utm-ptr
```

### Print Hello PTR

Change the directory

```
 cd lab0
```

Use this command in the terminal to open the Elixir's Interactive Shell

```
 iex -S mix
```

Execute the function to print the message

```
iex(1)> Week1.hello_ptr()
Hello PTR
```

### Execute the unit test

Use this command in the terminal to run the unit test

```
 mix test
```

## Week 2

These are the tasks for the second week.

## Tasks

Write a function that determines whether an input integer is prime.

```elixir
  def is_prime?(n) when n <= 1, do: :false
  def is_prime?(n) when n in [2, 3], do: :true
  def is_prime?(n) do
    floored_sqrt = round(Float.floor(:math.sqrt(n)))
    !Enum.any?(2..floored_sqrt, fn number -> rem(n, number) == 0 end)
  end
``` 
 
Write a function to calculate the area of a cylinder, given it’s height and radius.

```elixir
  def cylinder_area(height, radius) do
    area = 2 * :math.pi * radius * (height + radius)
    Float.ceil(area, 4)
  end
```

Write a function to reverse a list.

```elixir
  def reverse(list) do
    do_reverse(list, [])
  end

  defp do_reverse([h|t], reversed) do
    do_reverse(t, [h|reversed])
  end

  defp do_reverse([], reversed) do
    reversed
  end
```

Write a function to calculate the sum of unique elements in a list.

```elixir
  def unique_sum(list) do
    unique_list = Enum.uniq(list)
    Enum.sum(unique_list)
  end
```

Write a function that extracts a given number of randomly selected elements from a list.

```elixir
  def extract_random_number(list, n) do
    shuffled_list = Enum.sort_by(list, fn _ -> :rand.uniform() end)
    Enum.take(shuffled_list, n)
  end
```

Write a function that returns the first n elements of the Fibonacci sequence.

```elixir
  def first_fibonacci_elements(x) do
    for n <- 0..x - 1, do: fib(n)
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n) when n > 1 do
    fib(n - 1) + fib(n - 2)
  end
```

Write a function that, given a dictionary, would translate a sentence. Words not found in the dictionary need not be translated.

```elixir
  def translate(dictionary, string) do
    words = String.split(string, " ", [trim: true])
    translated_words = Enum.map(words, fn word -> dictionary[String.to_atom(word)] || word end)
    Enum.join(translated_words, " ")
  end
```

Write a function that receives as input three digits and arranges them in an order that would create the smallest possible number. Numbers cannot start with a 0.

```elixir
  def smallest_number(a, b, c) do
    numbers = [a, b, c]
    numbers = Enum.sort(numbers)
    first_non_zero = Enum.find(numbers, fn number -> number != 0 end)
    numbers = List.delete(numbers, first_non_zero)
    numbers = [first_non_zero | numbers]
    smallest_num = Enum.join(numbers)
    String.to_integer(smallest_num)
  end
```

Write a function that would rotate a list n places to the left.

```elixir
  def rotate_left(list, number) do
    to_rotate = Enum.drop(list, number)
    remaining = Enum.take(list, number)
    to_rotate ++ remaining
  end
```

Write a function that lists all tuples a, b, c such that a^2 + b^2 = c^2 and a, b ≤ 20.

```elixir
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
```

Write a function that eliminates consecutive duplicates in a list.

```elixir
  def remove_consecutive_duplicates(list) do
    Enum.dedup(list)
  end
```

``` 

