defmodule ExRoboCopTest do
  use ExUnit.Case
  doctest ExRoboCop

  test "greets the world" do
    assert ExRoboCop.hello() == :world
  end
end
