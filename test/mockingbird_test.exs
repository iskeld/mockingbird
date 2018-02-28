defmodule MockingbirdTest do
  use ExUnit.Case
  doctest Mockingbird

  test "greets the world" do
    assert Mockingbird.hello() == :world
  end
end
