defmodule Lab0Test do
  use ExUnit.Case
  doctest Lab0

  test "message is Hello PTR" do
    assert Lab0.print_hello() == :message
  end
end
