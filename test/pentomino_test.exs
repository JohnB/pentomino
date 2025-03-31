defmodule PentominoTest do
  use ExUnit.Case
  doctest Pentomino

  describe "all/0" do
    test "returns entire list" do
      all = Pentomino.all()
      assert Enum.count(all) == 21
    end
  end

  describe "piece/1" do
    test "returns the list of cells for the piece" do
      assert Pentomino.piece(0) == {:ok, [0]}
      assert Pentomino.piece(1) == {:ok, [0, 1]}
      assert Pentomino.piece(9) == {:ok, [1, 2, 5, 6, 11]}
    end

    test "returns end-of-list values for negative piece number" do
      assert Pentomino.piece(-1) == {:ok, [1, 2, 6, 10, 11]}
      assert Pentomino.piece(-2) == {:ok, [0, 1, 2, 3, 6]}
    end

    test "returns nil for too-large piece number" do
      assert Pentomino.piece(22) == :error
    end
  end
end
