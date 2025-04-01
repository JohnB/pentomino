defmodule Pentomino do
  @moduledoc """
    Pentomino is what this project calls the shape made from five (or fewer) adjoining squares.
    These shapes are the sum of the set of pentominos, tetrominos, trominos,
    and the domino and monomino - but we'll call it by its biggest shapes - the Pentomino.
    Wikipedia lumps them under ["Polyomino"](https://en.wikipedia.org/wiki/Polyomino)
    
    Each pentomino shape is represented as a set of cell positions in a 5x5 grid.
    However, the 5x5 grid has been flattened to an array, with positions
    represented by a single integer in the range 0 to 24
    
  """
  defstruct [:cells]

  @max_dimension 5
  @max_grid @max_dimension * @max_dimension
  @shapes [
    # monomio or dot
    [0],
    # domino or n-dash
    [0, 1],
    # m-dash or straight-3
    [0, 1, 2],
    # small angle
    [0, 1, 5],
    # straight-4
    [0, 1, 2, 3],
    # short L
    [0, 1, 2, 5],
    # short T
    [0, 1, 2, 6],
    # square
    [0, 1, 5, 6],
    # squiggle
    [1, 2, 5, 6],
    # see image at https://gp.home.xs4all.nl/Pieces.GIF
    # F
    [1, 2, 5, 6, 11],
    # I or straight-5
    [0, 1, 2, 3, 4],
    # L
    [0, 1, 2, 3, 5],
    # N
    [0, 1, 2, 7, 8],
    # P
    [0, 1, 2, 5, 6],
    # big T
    [0, 1, 2, 6, 11],
    # U
    [0, 1, 2, 5, 7],
    # V, or big angle
    [0, 1, 2, 5, 10],
    # W
    [1, 2, 5, 6, 10],
    # X
    [1, 5, 6, 7, 11],
    # Y
    [0, 1, 2, 3, 6],
    # Z
    [1, 2, 6, 10, 11]
  ]

  @doc """
  List all the pentominos, with no rotations or flips.
  """
  def all do
    @shapes
    |> Enum.map(fn cells -> %Pentomino{cells: cells} end)
  end

  @doc """
  Return one particular shape, indexed from 0 to 20.
  Returns :error for a too-large index, but negative indexes
  select from the end of the list.
  """
  def shape(index) do
    case Enum.fetch(all(), index) do
      {:ok, pentomino} -> pentomino
      anything_else -> anything_else
    end
  end

  @doc """
  Convert from an index to the X offset.
  """
  def x_offset(index), do: Integer.mod(index, @max_dimension)

  @doc """
  Convert from an index to the Y offset.
  """
  def y_offset(index), do: Integer.floor_div(Integer.mod(index, @max_grid), @max_dimension)

  @doc """
  Convert from an index to an `[X,Y]` list.
  """
  def index_to_xy(index) do
    [_x, _y] = [x_offset(index), y_offset(index)]
  end

  @doc """
  Convert from an `[X,Y]` list to the corresponding index.
  """
  def xy_to_index([x, y], width \\ @max_dimension) do
    x + width * y
  end

  # flipping and rotating may move the shape away from the (0,0) origin
  # so this should snug it up and to the left.
  @doc false
  def snug(pentomino) do
    min_x = pentomino.cells |> Enum.map(fn idx -> x_offset(idx) end) |> Enum.min()
    min_y = pentomino.cells |> Enum.map(fn idx -> y_offset(idx) end) |> Enum.min()
    offset = min_x + min_y * @max_dimension

    %Pentomino{
      cells: Enum.map(pentomino.cells, fn idx -> idx - offset end) |> Enum.sort()
    }
  end

  @doc """
  Flip a pentomino's cells to a new set of cells that
  has been "snugged up" to the top-left corner.
  """
  def flip_top_to_bottom(pentomino) do
    %Pentomino{
      cells:
        pentomino.cells
        |> Enum.map(fn index ->
          [x, y] = index_to_xy(index)
          xy_to_index([x, @max_dimension - 1 - y])
        end)
    }
    |> snug()
  end

  @doc """
  Flip a pentomino's cells to a new set of cells that
  has been "snugged up" to the top-left corner.
  """
  def flip_side_to_side(pentomino) do
    %Pentomino{
      cells:
        pentomino.cells
        |> Enum.map(fn index ->
          [x, y] = index_to_xy(index)
          xy_to_index([@max_dimension - 1 - x, y])
        end)
    }
    |> snug()
  end

  @doc """
  Rotate a shape and snug it to the top-left corner.
  """
  def rotate_left(pentomino) do
    core_rotate_left(pentomino) |> snug()
  end

  @doc """
  Rotate a shape and snug it to the top-left corner.
  """
  def rotate_right(pentomino) do
    pentomino
    |> core_rotate_left
    |> core_rotate_left
    |> core_rotate_left
    |> snug()
  end

  @doc false
  defp core_rotate_left(pentomino) do
    %Pentomino{
      cells:
        pentomino.cells
        |> Enum.map(fn index ->
          [x, y] = index_to_xy(index)
          xy_to_index([y, @max_dimension - 1 - x])
        end)
    }
  end
end
