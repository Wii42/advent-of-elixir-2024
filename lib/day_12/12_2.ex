Code.require_file("../utils/matrix.ex")

defmodule AdventOfElixir2024.Day12_2 do
  @moduledoc "Solution for day 12, part 2 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("12_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("12_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    matrix = Matrix.from_string(input)
    # Matrix.print(matrix)
    matrix = Matrix.map(matrix, fn x -> {x, nil} end)

    {region_matrix, _nr_of_regions} = assign_regions(matrix)
    # |> Matrix.print()
    region_matrix |> Matrix.map(fn {_, region} -> Integer.to_string(region) end)
    regions = get_regions(region_matrix) |> Map.values()

    Enum.map(regions, fn region -> {length(region), get_region_perimeter(region) |> group_perimeter_into_sides()} end)
  end

  defp find_plant({x, y}, plant, matrix, region_count) do
    with z when not is_nil(z) <- matrix[y][x],
         {current_plant, region} <- z,
         nil <- region,
         true <- current_plant == plant do
      updated_matrix = put_in(matrix, [y, x], {current_plant, region_count})

      Enum.reduce(directions(), updated_matrix, fn {dirx, diry}, mat ->
        find_plant({x + dirx, y + diry}, plant, mat, region_count)
      end)
    else
      # Return matrix if any condition fails
      _ -> matrix
    end
  end

  def directions(), do: [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def assign_regions(matrix) do
    Matrix.reduce_by_position(matrix, {matrix, 0}, fn x, y, {mat, region_count} ->
      {plant, region} = mat[y][x]

      if region != nil do
        {mat, region_count}
      else
        {find_plant({x, y}, plant, mat, region_count), region_count + 1}
      end
    end)
  end

  defp get_regions(region_matrix), do: Matrix.position_map(region_matrix)

  defp get_region_perimeter(region) do
    Enum.reduce(region, [], fn {x, y}, acc ->
      Enum.reduce(directions(), acc, fn {dirx, diry}, acc2 ->
        possible_perimeter = {x + dirx, y + diry}
        if possible_perimeter not in region, do: [possible_perimeter | acc2], else: acc2
      end)
    end)
  end

  defp group_perimeter_into_sides(region_perimeter) do
    Enum.map(region_perimeter, fn perimeter ->
      Enum.reduce(directions(), [], fn dir, acc ->
        get_side(perimeter, region_perimeter, dir) ++ acc
      end) #|> Enum.chunk_every(2)
    end)
  end

  defp get_side({x,y}, all, {dirx, diry}) do
    if {x,y} in all do
      possible = {x+dirx, y+diry}
      [{x,y} | get_side(possible, all, possible)]
    else
      []
    end
  end
end

AdventOfElixir2024.Day12_2.test()
