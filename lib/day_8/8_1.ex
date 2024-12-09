Code.require_file("../utils/matrix.ex")

defmodule AdventOfElixir2024.Day8_1 do
  def test() do
    {:ok, input} = File.read("8_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("8_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    matrix = Matrix.from_string(input) |> Matrix.print()

    position_map =
      filter_matrix(matrix, fn x -> x != ?. end)
      |> position_map()

    position_map |> position_map_to_string() |> IO.inspect()

    antinodes_map =
      Enum.map(position_map, fn {key, value} -> {key, calculate_antinodes(value, [])} end)
      |> Enum.into(%{})

    antinodes = Map.values(antinodes_map) |> List.flatten()

    antinodes = antinodes |> Enum.uniq()|> Enum.filter( fn {x,y} -> matrix[y][x] != nil end)

    antinodes_matrix =
      Enum.reduce(
        antinodes,
        matrix, fn {antinode_x, antinode_y}, acc ->  acc =put_in(acc[antinode_y][antinode_x], ?#)
      #SMatrix.print(acc)
    acc end
      )

    antinodes_matrix |> Matrix.print()
    length(antinodes)

  end

  def filter_matrix(matrix, fun) do
    Enum.map(matrix, fn {key, row} ->
      new_val = Map.filter(row, fn {_, val} -> fun.(val) end)
      {key, new_val}
    end)
    |> Enum.into(%{})
    |> Map.filter(fn {_key, value} -> not (Map.values(value) |> Enum.empty?()) end)
  end

  def position_map(matrix) do
    Enum.map(matrix, fn {key, row} ->
      values_map(row, key)
    end)
    |> Enum.reduce(%{}, fn map, acc ->
      Map.merge(map, acc, fn _, val1, val2 -> val1 ++ val2 end)
    end)
  end

  defp values_map(map, index) do
    Enum.reduce(map, %{}, fn {k, val}, acc ->
      list = Map.get(acc, val, [])
      Map.put(acc, val, [{k, index} | list])
    end)
  end

  defp position_map_to_string(map),
    do:
      map
      |> Enum.map(fn {key, value} -> {<<key>>, value} end)
      |> Enum.into(%{})

  defp calculate_antinodes([], antinodes), do: antinodes

  defp calculate_antinodes(position_list, antinodes) do
    [head | rest] = position_list
    pairs = for x <- rest, do: find_antinode_for(head, x)
    pairs = List.flatten(pairs)
    calculate_antinodes(rest, antinodes ++ pairs)
  end

  defp find_antinode_for({x1, y1}, {x2, y2}) do
    {dir_x, dir_y} = {x2 - x1, y2 - y1}
    [{x1 - dir_x, y1 - dir_y}, {x2 + dir_x, y2 + dir_y}]
  end
end

AdventOfElixir2024.Day8_1.prod()
