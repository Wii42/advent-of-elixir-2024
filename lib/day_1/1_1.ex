defmodule AdventOfElixir2024.Day1_1 do
  @moduledoc """
  Documentation for `AdventOfElixir2024`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AdventOfElixir2024.hello()
      :world

  """
  def test() do
    {:ok, input} = File.read("1_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("1_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    lines = String.split(input, "\r\n")
    first_part = for line <- lines, do: get_nth_elem(line, 0)
    second_part = for line <- lines, do: get_nth_elem(line, 1)
    first_part = Enum.sort(first_part)
    second_part = Enum.sort(second_part)
    Enum.reduce(Enum.zip(first_part, second_part), 0, fn {a, b}, acc -> abs(a - b) + acc end)
  end

  defp get_nth_elem(line, index) do
    parts = String.split(line, " ", trim: true)
    Enum.at(parts, index) |> String.to_integer()
  end
end

AdventOfElixir2024.Day1_1.prod()
