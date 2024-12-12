defmodule AdventOfElixir2024.Day11_1 do
  def test() do
    {:ok, input} = File.read("11_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("11_input.txt")
    # solution_bf(input) |> IO.inspect()
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    list = String.split(input, " ") |> Enum.map(fn x -> {String.to_integer(x), 1} end)
    IO.inspect(list)

    compressed_list = blink_multiple(list, 75)
    IO.inspect(compressed_list |> length(), label: "list length")
    count_occurences(compressed_list)
  end

  def solution_bf(input) do
    list = String.split(input, " ") |> Enum.map(&String.to_integer/1)

    blink_multiple_bf(list, 75) |> length()
  end

  def blink(stones) do
    Enum.reduce(stones, [], fn {stone, count}, acc ->
      if stone == 0 do
        [{1, count} | acc]
      else
        if digits_even?(stone) do
          digits = Integer.digits(stone)
          length = length(digits)
          mid = div(length, 2)
          {first_half, second_half} = Enum.split(digits, mid)
          first_half = int_list_to_int(first_half)
          second_half = int_list_to_int(second_half)

          if first_half == second_half do
            [{first_half, 2*count} | acc]
          else
            [{second_half, count}, {first_half, count} | acc]
          end
        else
          [{stone * 2024, count} | acc]
        end
      end
    end)
    |> Enum.group_by(fn {stone, _} -> stone end)
    |> Enum.map(fn {key, values} ->
      {key, count_occurences(values)}
    end)

    # |>Enum.reverse()
  end

  defp count_occurences(stones), do: Enum.map(stones, fn {_, count} -> count end) |> Enum.sum()

  def blink_multiple(stones, n) do
    Enum.reduce(1..n, stones, fn i, acc -> blink(acc) |> IO.inspect(label: i) end)
  end

  def blink_bf(stones) do
    Enum.reduce(stones, [], fn stone, acc ->
      if stone == 0 do
        [1 | acc]
      else
        if digits_even?(stone) do
          digits = Integer.digits(stone)
          length = length(digits)
          mid = div(length, 2)
          {first_half, second_half} = Enum.split(digits, mid)
          first_half = int_list_to_int(first_half)
          second_half = int_list_to_int(second_half)
          [second_half, first_half | acc]
        else
          [stone * 2024 | acc]
        end
      end
    end)

    # |> Enum.reverse()
  end

  def blink_multiple_bf(stones, n) do
    Enum.reduce(1..n, stones, fn i, acc -> blink_bf(acc) |> IO.inspect(label: i) end)
  end

  def digits_even?(stone) do
    :math.log10(stone) |> floor() |> rem(2) == 1
  end

  defp int_list_to_int(int_list),
    do: Enum.reduce(int_list, 0, fn digit, acc -> acc * 10 + digit end)
end

AdventOfElixir2024.Day11_1.prod()
