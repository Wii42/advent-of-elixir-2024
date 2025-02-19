defmodule AdventOfElixir2024.Day25_1 do
  @moduledoc "Solution for day 25, part 1 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("25_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("25_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    {keys, locks} =
      input
      |> String.split("\r\n\r\n")
      |> Enum.split_with(fn pattern -> String.starts_with?(pattern, "#####\r\n") end)

    keys = keys |> Enum.map(&column_heights/1)
    locks = locks |> Enum.map(&column_heights/1)

    (for key <- keys, lock <- locks, key_fits_lock(key, lock), do: 1) |> Enum.sum()
  end

  def column_heights(pattern) do
    pattern
    |> String.split("\r\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.zip()
    |> Enum.map(fn column ->
      column |> Tuple.to_list() |> Enum.count(fn char -> char == ?# end)
    end)
  end

  def key_fits_lock(key, lock) do
    Enum.zip_with(key, lock, fn x, y -> x+y end) |> Enum.all?(fn sum -> sum <= 7 end)
  end
end

AdventOfElixir2024.Day25_1.prod()
