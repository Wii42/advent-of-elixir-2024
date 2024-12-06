defmodule AdventOfElixir2024.Day6_1 do
  def test() do
    {:ok, input} = File.read("6_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("6_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    matrix =
      String.split(input, "\r\n")
      |> Enum.map(fn line -> String.to_charlist(line) |> as_indexed_map() end)
      |> as_indexed_map()

    IO.puts(matrix_to_string(matrix))
    pointer = find_pointer(matrix)
    end_matrix = move_pointer(matrix, pointer, directions())
    count_symbol(end_matrix, ?X)
  end

  defp as_indexed_map(list) do
    Enum.with_index(list) |> Map.new(fn {value, key} -> {key, value} end)
  end

  defp directions(), do: [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]

  defp find_pointer(matrix) do
    target_value = ?^

    matrix
    |> Enum.find(fn {_outer_key, inner_map} ->
      case inner_map do
        %{} -> Enum.any?(inner_map, fn {_inner_key, val} -> val == target_value end)
        _ -> false
      end
    end)
    |> case do
      {outer_key, inner_map} ->
        {inner_key, _} = Enum.find(inner_map, fn {_inner_key, val} -> val == target_value end)
        {outer_key, inner_key}

      nil ->
        nil
    end
  end

  def matrix_to_string(matrix) do
    Enum.map(Map.values(matrix), fn line -> List.to_string(Map.values(line)) end)
    |> Enum.join("\r\n")
  end

  def move_pointer(matrix, pointer, directions) do
    {pointer_y, pointer_x} = pointer
    [dir | other_directions] = directions
    {x_dir, y_dir} = dir

    matrix = put_in(matrix[pointer_y][pointer_x], ?X)
    new_pointer_x = pointer_x + x_dir
    new_pointer_y = pointer_y + y_dir
    next_value = matrix[new_pointer_y][new_pointer_x]

    case next_value do
      nil ->
        matrix_to_string(matrix) |> IO.puts()
        matrix

      ?# ->
        move_pointer(matrix, pointer, other_directions ++ [dir])

      _ ->
        matrix = put_in(matrix[new_pointer_y][new_pointer_x], ?^)
        matrix |> matrix_to_string() |> IO.puts()
        IO.puts("")
        move_pointer(matrix, {new_pointer_y, new_pointer_x}, directions)
    end
  end

  defp count_symbol(matrix, symbol) do
    Enum.map(Map.values(matrix), fn line ->
      Enum.count(Map.values(line), fn elem -> elem == symbol end)
    end) |> Enum.sum()
  end
end

AdventOfElixir2024.Day6_1.prod()
