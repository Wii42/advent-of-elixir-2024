defmodule AdventOfElixir2024.Day6_2 do
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
      |> Enum.map(fn line ->
        String.to_charlist(line) |> Enum.map(fn char -> [char] end) |> as_indexed_map()
      end)
      |> as_indexed_map()

    IO.puts(matrix_to_string(matrix))
    pointer = find_pointer(matrix)
    y_size = map_size(matrix) - 1
    x_size = map_size(matrix[0]) - 1
    IO.inspect(x_size * y_size, label: "to check")

    for(
      y <- 0..y_size,
      x <- 0..x_size,
      {y, x} != pointer,
      do: add_obstacle(matrix, pointer, {y, x})
    )
    |> Enum.count(fn x -> x == true end)
  end

  defp as_indexed_map(list) do
    Enum.with_index(list) |> Map.new(fn {value, key} -> {key, value} end)
  end

  defp directions(), do: [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]

  defp find_pointer(matrix) do
    target_value = [?^]

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
    Enum.map(Map.values(matrix), fn line ->
      Enum.map(Map.values(line), &hd/1) |> List.to_string()
    end)
    |> Enum.join("\r\n")
  end

  def move_pointer(matrix, pointer, directions) do
    {pointer_y, pointer_x} = pointer
    [dir | other_directions] = directions
    {x_dir, y_dir} = dir

    path_symbol =
      case dir do
        {0, -1} -> ?|
        {1, 0} -> ?-
        {0, 1} -> ?¦
        {-1, 0} -> ?_
      end

    current_value = matrix[pointer_y][pointer_x]

    if path_symbol in current_value do
      {true, matrix}
    else
      matrix = put_in(matrix[pointer_y][pointer_x], [path_symbol | current_value] |> Enum.uniq())
      new_pointer_x = pointer_x + x_dir
      new_pointer_y = pointer_y + y_dir
      next_value = matrix[new_pointer_y][new_pointer_x]

      next_top_value = if next_value == nil, do: nil, else: hd(next_value)

      case next_top_value do
        nil ->
          {false, matrix}

        ?# ->
          move_pointer(matrix, pointer, other_directions ++ [dir])

        _ ->
          matrix = put_in(matrix[new_pointer_y][new_pointer_x], [?^ | next_value])
          move_pointer(matrix, {new_pointer_y, new_pointer_x}, directions)
      end
    end
  end

  def add_obstacle(matrix, pointer, {y, x}) do
    matrix = put_in(matrix[y][x], [?#])
    {has_cicle, _} = move_pointer(matrix, pointer, directions())
    if x == 0, do: IO.inspect(has_cicle, label: "#{x}, #{y}")
    has_cicle
  end
end

AdventOfElixir2024.Day6_2.prod()
