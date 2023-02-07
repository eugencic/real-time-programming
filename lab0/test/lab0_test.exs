defmodule Lab0Test do
  use ExUnit.Case
  doctest Week1

  test "message is Hello PTR" do
    assert Week1.hello_ptr() == "Hello PTR"
  end
end
