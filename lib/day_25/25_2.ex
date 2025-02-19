defmodule AdventOfElixir2024.Day25_2 do
  @moduledoc "Solution for day 25, part 2 of Advent of Code 2024"

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
    # Your solution here
    input
  end
end

AdventOfElixir2024.Day25_2.test()
