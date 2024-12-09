Code.require_file("../utils/matrix.ex")

defmodule AdventOfElixir2024.Day8_2 do
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

    matrix_size = {length(Map.keys(matrix[0])), length(Map.keys(matrix))}

    position_map =
      filter_matrix(matrix, fn x -> x != ?. end)
      |> position_map()

    position_map |> position_map_to_string() |> IO.inspect()

    antinodes_map =
      Enum.map(position_map, fn {key, value} ->
        {key, calculate_antinodes(value, [], matrix_size)}
      end)
      |> Enum.into(%{})

    antinodes = Map.values(antinodes_map) |> List.flatten()

    antinodes = antinodes |> Enum.uniq()

    antinodes_matrix =
      Enum.reduce(
        antinodes,
        matrix,
        fn {antinode_x, antinode_y}, acc ->
          acc = put_in(acc[antinode_y][antinode_x], ?#)
          # SMatrix.print(acc)
          acc
        end
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

  defp calculate_antinodes([], antinodes, _), do: antinodes

  defp calculate_antinodes(position_list, antinodes, matrix_size) do
    [head | rest] = position_list
    pairs = for x <- rest, do: find_antinode_for(head, x, matrix_size)
    pairs = List.flatten(pairs)
    calculate_antinodes(rest, antinodes ++ pairs, matrix_size)
  end

  defp find_antinode_for({x1, y1}, {x2, y2}, matrix_size) do
    {dir_x, dir_y} = {x2 - x1, y2 - y1}
    step_in_direction({-dir_x, -dir_y}, [{x1, y1}], matrix_size) ++ step_in_direction({dir_x, dir_y}, [{x2, y2}], matrix_size)
  end

  defp step_in_direction({dir_x, dir_y}, steps, {matrix_size_x, matrix_size_y}) do
    {last_step_x, last_step_y} = hd(steps)
    next_step = {next_step_x, next_step_y} = {last_step_x + dir_x, last_step_y + dir_y}

    if next_step_x >= 0 and next_step_x < matrix_size_x and next_step_y >= 0 and
         next_step_y < matrix_size_y do
      step_in_direction({dir_x, dir_y}, [next_step | steps], {matrix_size_x, matrix_size_y})
    else
      steps
    end
  end
end

AdventOfElixir2024.Day8_2.prod()
