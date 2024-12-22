Code.require_file("../utils/matrix.ex")

defmodule AdventOfElixir2024.Day20_1 do
  @moduledoc "Solution for day 20, part 1 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("20_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("20_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    matrix = Matrix.from_string(input) |> Matrix.print()
    {y, x} = Matrix.find_value(matrix, ?S)
    start_pos = {x, y}
    counter = 0
    {pico_map, steps} = move_on_path(matrix, %{start_pos => counter}, start_pos, counter)
    IO.inspect(steps, label: "steps")
    shortcuts = find_all_shortcuts(pico_map)
    grouped_by_length = Enum.group_by(shortcuts, fn({{_, count1}, {_, count2}}) -> count2 - count1 - 2 end) #|> IO.inspect()
    number_of_lengths = Enum.map(grouped_by_length, fn {k, v} -> {k, length(v)}end)
    Enum.filter(number_of_lengths, fn {length, number} -> length >= 100 end) |> Enum.map(fn {_, n} -> n end) |> Enum.sum()
  end

  def move_on_path(matrix, pico_map, pos, counter) do
    {pos_next, char_next} = get_next_step(matrix, pos, directions(), pico_map)
    counter = counter + 1
    pico_map = Map.put(pico_map, pos_next, counter)

    if char_next == ?E,
      do: {pico_map, counter},
      else: move_on_path(matrix, pico_map, pos_next, counter)
  end

  defp get_next_step(_matrix, {x, y}, [], _pico_map), do: raise("No where to go at {#{x}, #{y}}")

  defp get_next_step(matrix, pos, directions, pico_map) do
    [dir | other_dirs] = directions
    new_pos = {x_new, y_new} = add_pos(pos, dir)
    next_field = matrix[y_new][x_new]

    if next_field == nil or next_field == ?# or pico_map[new_pos] != nil do
      get_next_step(matrix, pos, other_dirs, pico_map)
    else
      {new_pos, next_field}
    end
  end

  def find_all_shortcuts(pico_map) do
    list = Map.keys(pico_map)
    dirs = directions()
    Enum.map(list, fn pos -> find_shortcut(pos, dirs, pico_map) end) |> List.flatten()
  end

  defp find_shortcut(pos, directions, pico_map) do
    pos_count = pico_map[pos]

    possible_cheat =
      Enum.map(directions, fn dir ->
        other_side_pos = add_pos(pos, mult_pos(dir, 2))
        other_side_count = pico_map[other_side_pos]

        if other_side_count == nil or pos_count > other_side_count do
          nil
        else
          between = pico_map[add_pos(pos, dir)]
          if between == nil, do:
          {{pos, pos_count}, {other_side_pos, other_side_count}}, else: nil
        end
      end)

    Enum.filter(possible_cheat, fn x -> x != nil end)
  end

  def directions(), do: [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def add_pos({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def mult_pos({x, y}, factor), do: {factor * x, factor * y}

  def neg_pos(pos), do: mult_pos(pos, -1)

  def subt_pos(pos1, pos2), do: add_pos(pos1, neg_pos(pos2))
end

AdventOfElixir2024.Day20_1.test()
