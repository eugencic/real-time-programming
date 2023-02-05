defmodule Lab0Test do
  use ExUnit.Case
  doctest HelloPTR

  test "message is Hello PTR" do
    assert HelloPTR.hello_ptr() == :message
  end
end
