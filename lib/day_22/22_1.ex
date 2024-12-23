defmodule AdventOfElixir2024.Day22_1 do
  @moduledoc "Solution for day 22, part 1 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("22_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("22_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    lines = String.split(input, "\r\n")

    Enum.map(lines, fn line ->
      Enum.reduce(1..2000, String.to_integer(line), fn _, acc -> calculate_secret(acc) end)
    end) |> Enum.sum()
  end

  def mix(value, secret), do: Bitwise.bxor(value, secret)

  def prune(secret), do: rem(secret, 16_777_216)

  def calculate_secret(secret) do
    step1(secret) |> step2() |> step3()
  end

  defp step1(secret) do
    result = secret * 64
    mix(result, secret) |> prune()
  end

  defp step2(secret) do
    result = div(secret, 32)
    mix(result, secret) |> prune()
  end

  defp step3(secret) do
    result = secret * 2048
    mix(result, secret) |> prune()
  end
end

AdventOfElixir2024.Day22_1.prod()
