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
    test "returns the expected structure" do
      assert Pentomino.piece(0) == %Pentomino{cells: [0]}
      assert Pentomino.piece(1) == %Pentomino{cells: [0, 1]}
      assert Pentomino.piece(9) == %Pentomino{cells: [1, 2, 5, 6, 11]}
    end

    test "returns end-of-list structures for negative piece number" do
      assert Pentomino.piece(-1) == %Pentomino{cells: [1, 2, 6, 10, 11]}
      assert Pentomino.piece(-2) == %Pentomino{cells: [0, 1, 2, 3, 6]}
    end

    test "returns :error for too-large piece number" do
      assert Pentomino.piece(321) == :error
    end
  end

  describe "x_offset/1" do
    test "returns the X offset of the given index" do
      assert Pentomino.x_offset(0) == 0
      assert Pentomino.x_offset(1) == 1
      assert Pentomino.x_offset(5) == 0
      assert Pentomino.x_offset(-1) == 4
    end
  end

  describe "y_offset/1" do
    test "returns the Y offset of the given index" do
      assert Pentomino.y_offset(0) == 0
      assert Pentomino.y_offset(1) == 0
      assert Pentomino.y_offset(5) == 1
      assert Pentomino.y_offset(6) == 1
      assert Pentomino.y_offset(10) == 2
      assert Pentomino.y_offset(345) == 4
    end

    test "returns a modulo Y value for a negative index" do
      assert Pentomino.y_offset(-1) == 4
      assert Pentomino.y_offset(-2) == 4
      assert Pentomino.y_offset(-5) == 4
      assert Pentomino.y_offset(-6) == 3
      assert Pentomino.y_offset(-345) == 1
    end
  end

  describe "index_to_xy/1" do
    test "returns the [X,Y] offset of the given index" do
      assert Pentomino.index_to_xy(0) == [0, 0]
      assert Pentomino.index_to_xy(1) == [1, 0]
      assert Pentomino.index_to_xy(5) == [0, 1]
      assert Pentomino.index_to_xy(-1) == [4, 4]
    end
  end

  describe "xy_to_index/1" do
    test "returns the index value for the given [X,Y] offset" do
      assert Pentomino.xy_to_index([0, 0]) == 0
      assert Pentomino.xy_to_index([1, 0]) == 1
      assert Pentomino.xy_to_index([0, 1]) == 5
      assert Pentomino.xy_to_index([4, 4]) == 24
    end
  end

  describe "flip_top_to_bottom/1" do
    test "returns a new pentomino that has been flipped top-to-bottom and 'snugged'" do
      assert Pentomino.flip_top_to_bottom(%Pentomino{cells: [0]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_top_to_bottom(%Pentomino{cells: [1]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_top_to_bottom(%Pentomino{cells: [2]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_top_to_bottom(%Pentomino{cells: [9, 10]}) == %Pentomino{cells: [0, 9]}

      assert Pentomino.flip_top_to_bottom(%Pentomino{cells: [1, 2, 5, 6, 11]}) == %Pentomino{
               cells: [1, 5, 6, 11, 12]
             }
    end
  end

  describe "flip_side_to_side/1" do
    test "returns a new pentomino that has been flipped side-to-side and 'snugged'" do
      assert Pentomino.flip_side_to_side(%Pentomino{cells: [0]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_side_to_side(%Pentomino{cells: [1]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_side_to_side(%Pentomino{cells: [2]}) == %Pentomino{cells: [0]}
      assert Pentomino.flip_side_to_side(%Pentomino{cells: [9, 10]}) == %Pentomino{cells: [0, 9]}

      assert Pentomino.flip_side_to_side(%Pentomino{cells: [1, 2, 5, 6, 11]}) == %Pentomino{
               cells: [0, 1, 6, 7, 11]
             }
    end
  end

  describe "rotate_left/1" do
    test "returns a new pentomino that has been rotated leftward and 'snugged'" do
      assert Pentomino.rotate_left(%Pentomino{cells: [0]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_left(%Pentomino{cells: [1]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_left(%Pentomino{cells: [2]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_left(%Pentomino{cells: [9, 10]}) == %Pentomino{cells: [0, 21]}

      assert Pentomino.rotate_left(%Pentomino{cells: [1, 2, 5, 6, 11]}) == %Pentomino{
               cells: [0, 5, 6, 7, 11]
             }
    end
  end

  describe "rotate_right/1" do
    test "returns a new pentomino that has been rotated rightward and 'snugged'" do
      assert Pentomino.rotate_right(%Pentomino{cells: [0]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_right(%Pentomino{cells: [1]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_right(%Pentomino{cells: [2]}) == %Pentomino{cells: [0]}
      assert Pentomino.rotate_right(%Pentomino{cells: [9, 10]}) == %Pentomino{cells: [0, 21]}

      assert Pentomino.rotate_right(%Pentomino{cells: [1, 2, 5, 6, 11]}) == %Pentomino{
               cells: [1, 5, 6, 7, 12]
             }
    end
  end
end
