defmodule AdventOfElixir2024.Day11_1 do
  def test() do
    {:ok, input} = File.read("11_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("11_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    list = String.split(input, " ") |> Enum.map(&String.to_integer/1)

    blink_multiple(list, 25) |> length()
  end

  def blink(stones) do
    Enum.reduce(stones, [], fn stone, acc ->
      if stone == 0 do
        [1 | acc]
      else
        string = Integer.to_string(stone)
        string_length = String.length(string)

        if rem(string_length, 2) == 0 do
          mid = div(string_length, 2)
          first_half = String.slice(string, 0, mid)
          second_half = String.slice(string, mid, string_length - mid)
          [String.to_integer(second_half), String.to_integer(first_half) | acc]
        else
          [stone * 2024 | acc]
        end
      end
    end)
    |> Enum.reverse()
  end

  def blink_multiple(stones, n) do
    Enum.reduce(1..n, stones, fn _, acc -> blink(acc) |> IO.inspect() end)
  end

  def digits(stone) do
    (:math.log10(stone) + 1) |> floor() |> rem(2) == 0
  end
end

AdventOfElixir2024.Day11_1.test()
