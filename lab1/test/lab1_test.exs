defmodule Lab1Test do
  use ExUnit.Case
  doctest Lab1

  test "message is Hello PTR" do
    assert Lab1.hello_ptr() == IO.puts("Hello PTR")
  end
end
