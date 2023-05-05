defmodule Week1 do
  def hello_ptr do
    message = "Hello PTR"
    IO.puts(message)
    message
  end
end

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

  def remove_consecutive_duplicates(list) do
    Enum.dedup(list)
  end
end

defmodule Week3 do
  def print_message do
    receive do
      message -> IO.puts(message)
    end
    print_message()
  end

  def modify_message do
    receive do
      message ->
        modified_message = change_message(message)
        IO.puts("Received: #{modified_message}")
    end
    modify_message()
  end

  def change_message(message) do
    case message do
      int when is_integer(int) -> int + 1
      str when is_binary(str) -> String.downcase(str)
      _ -> "I don't know how to HANDLE this!"
    end
  end

  def average(total, count) do
    receive do
      number ->
        new_total = total + number
        new_count = count + 1
        average = new_total / new_count
        IO.puts("Current average is: #{average}")
        average(new_total, new_count)
    end
  end
end

defmodule Week3MonitoringActor do
  def run_monitoring_actor do
    IO.puts("The monitoring actor has started.")
    spawn_monitor(Week3MonitoredActor, :run_monitored_actor, [])
    receive do
      {:DOWN, _ref, :process, _from_pid, reason} -> IO.puts("The monitoring actor has detected that the monitored actor has stopped. Exit reason: #{reason}.")
      Process.sleep(5000)
    end
    run_monitoring_actor()
  end
end

defmodule Week3MonitoredActor do
    def run_monitored_actor do
    IO.puts("The monitored actor has started.")
    Process.sleep(5000)
    IO.puts("The monitored actor has finished.")
    exit(:crash)
  end
end

defmodule Week4WorkingActor do
  def run_working_actor do
    pid = spawn(Week4WorkingActor, :working_actor, [])
    name = for _ <- 1..8, into: "", do: <<Enum.random('abcdefghijklmnopqrstuvwxyz')>>
    Process.register(pid, String.to_atom(name))
    IO.puts("Worker with Id: (#{inspect(pid)}) and Name: (:#{name}) has been created")
    pid
  end

  def working_actor do
    receive do
      :kill ->
        exit(:kill)
      message -> IO.puts("Worker with Id: (#{inspect(self())}) received a message: #{inspect(message)}")
    end
    working_actor()
  end
end

defmodule Week4SupervisedPool do
  def run_supervised_pool(n) do
    IO.puts("Supervisor has started")
    processes = Enum.map(1..n, fn _ -> Week4WorkingActor.run_working_actor() end)
    spawn(Week4SupervisedPool, :supervised_pool, [processes])
  end

  def supervised_pool(processes) do
    IO.puts("Workers monitored by the supervisor: #{inspect(processes)}")
    Enum.map(processes, fn process-> Process.monitor(process) end)

    receive do
      {:DOWN, _ref, :process, pid, :kill} -> IO.puts("Worker with Id: (#{inspect(pid)}) has finished. Creating and monitoring a new worker")
      new_pid = Week4WorkingActor.run_working_actor()
      processes = List.delete(processes, pid)
      processes = [new_pid] ++ processes
      supervised_pool(processes)
    end
  end
end

defmodule Week5 do
  def request do
    import HTTPoison
    import Floki

    url = "https://quotes.toscrape.com/"
    response = get!(url)

    IO.puts("Status code: #{inspect(response.status_code)}")
    IO.puts("Headers: #{inspect(response.headers)}")
    IO.puts("Body : #{inspect(response.body)}")

    quotes = parse_document!(response.body)
             |> find(".quote")
             |> Enum.map(fn quote ->
                  text = quote |> find(".text") |> text()
                  author = quote |> find(".author") |> text()
                  tags = quote |> find(".tag") |> Enum.map(&text/1)
                  %{text: text, author: author, tags: tags}
                end)

    IO.puts("Found #{length(quotes)} quotes:")
    Enum.each(quotes, fn quote ->
      IO.puts("#{quote.text}\n - #{quote.author}\n Tags: #{inspect(quote.tags)}\n")
    end)

    save_quotes(quotes)
  end

  defp save_quotes(quotes) do
    import Jason
    json = encode!(quotes)
    File.write("quotes.json", json)
    IO.puts("Quotes saved in quotes.json")
  end
end
