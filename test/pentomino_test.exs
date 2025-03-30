defmodule PentominoTest do
  use ExUnit.Case
  doctest Pentomino

  test "greets the world" do
    assert Pentomino.hello() == :world
  end
end
