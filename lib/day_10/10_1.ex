import Bitwise
Code.require_file("../utils/matrix.ex")

defmodule AdventOfElixir2024.Day10_1 do
  def test() do
    {:ok, input} = File.read("10_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("10_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    matrix = Matrix.from_string(input) |> Matrix.print()
    matrix = Matrix.map(matrix, fn x -> {single_digit_ascii_to_int(x), false} end)

    start_positions =
      (Matrix.filter(matrix, fn {x, _} -> x == 0 end) |> Matrix.position_map())[{0, false}]

    #IO.inspect(start_positions)

    scores =
      Enum.map(start_positions, fn pos ->
        {endpoints, _} = search(matrix, pos, -1)
        endpoints
      end)

    #IO.inspect(scores)

    scores = Enum.map(scores, &length/1)
    IO.inspect(scores)
    Enum.sum(scores)

    # search(matrix, {0, 0}, -1)
    # :ok
  end

  def single_digit_ascii_to_int(digit), do: digit &&& 0x0F

  defp directions(), do: [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

  def search(matrix, {x, y}, elevation_before) do
    z = matrix[y][x]
    {current_elevation, reached_before} = if z == nil, do: {nil, false}, else: z

    if current_elevation == nil or reached_before do
      # if reached_before, do: IO.inspect({x,y}, label: "reached before")
      {[], matrix}
    else
      if current_elevation - elevation_before == 1 do
        matrix = put_in(matrix, [y, x], {current_elevation, true})
        # IO.inspect(matrix, label: "#{x},#{y}")
        find_next_step(matrix, {x, y}, current_elevation)
      else
        {[], matrix}
      end
    end
  end

  defp find_next_step(matrix, {x, y}, 9), do: {[{x, y}], matrix}

  defp find_next_step(mat, {x, y}, current_elevation) do
    Enum.reduce(directions(), {[], mat}, fn {x_dir, y_dir}, {endpoints, matrix} ->
      {p, new_matrix} = search(matrix, {x + x_dir, y + y_dir}, current_elevation)
      {p ++ endpoints, new_matrix}
    end)
  end
end

AdventOfElixir2024.Day10_1.prod()
