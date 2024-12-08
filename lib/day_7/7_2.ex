defmodule AdventOfElixir2024.Day7_2 do
  def test() do
    {:ok, input} = File.read("7_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("7_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    lines = String.split(input, "\r\n")

    lines = Enum.map(lines, fn line -> String.split(line, ": ") end)
    [results, equations] = Enum.zip(lines)
    results = results |> Tuple.to_list() |> Enum.map(&String.to_integer/1)

    equations =
      equations
      |> Tuple.to_list()
      |> Enum.map(fn line ->
        String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1)
      end)

    parsed_lines = Enum.zip(results, equations)

    possible_solutions =
      Enum.map(parsed_lines, fn {solution, parts} ->
        {solution, possible_equations(solution, parts)}
      end)

    have_solutions =
      Enum.filter(possible_solutions, fn {solution, possible} -> solution in possible end)

    Enum.map(have_solutions, fn x -> elem(x, 0) end) |> Enum.sum()
  end

  defp possible_equations(solution, parts) do
    Enum.reduce(parts, [], fn part, acc -> parts_reducer(part, acc, solution) end)
  end

  defp parts_reducer(part, [], _), do: [part]

  defp parts_reducer(part, acc, solution),
    do:
      Enum.map(acc, fn part_solution ->
        [part_solution + part, part_solution * part, concat(part_solution, part)]
      end)
      |> List.flatten()
      |> Enum.filter(fn x -> x <= solution end)

  defp concat(int1, int2) do
    (Integer.to_string(int1) <> Integer.to_string(int2)) |> String.to_integer()
  end
end

AdventOfElixir2024.Day7_2.prod()
