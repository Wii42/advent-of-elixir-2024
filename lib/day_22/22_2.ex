defmodule AdventOfElixir2024.Day22_2 do
  @moduledoc "Solution for day 22, part 2 of Advent of Code 2024"

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

    secrets =
      Enum.map(lines, fn line ->
        number = String.to_integer(line)

        t =
          Enum.reduce(1..2000, [number], fn _, [acc | other] ->
            next = calculate_secret(acc)
            [next, acc | other]
          end)

        t = Enum.reverse(t)

        prices = Enum.map(t, fn x -> Integer.digits(x) |> List.last() end)

        Enum.reduce(prices, nil, fn price, acc ->
          if acc == nil do
            [{price, nil}]
          else
            {last_price, _} = hd(acc)
            [{price, price - last_price} | acc]
          end
        end)
        |> Enum.reverse()
      end)

    #found_changes =
    #  Enum.map(secrets, fn y -> Enum.map(y, fn x -> elem(x, 1) end) |> Enum.uniq() end)

    combinations = get_combinations(-9..9)

    sold_bananas(secrets, combinations)

    #Enum.frequencies(secrets)


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

  defp get_combinations(range) do
    for i <- range,
        j <- range,
        k <- range,
        l <- range,
        cominations_filter(i, j, k, l, range),
        do: [i, j, k, l]
  end

  defp cominations_filter(i, j, k, l, range) do
    with a <- i + j,
         true <- a in range,
         b <- a + k,
         true <- b in range,
         c <- b + l,
         true <- c in range do
      true
    else
      _ -> false
    end
  end

  defp get_bananas([], _sequence), do: nil

  defp get_bananas(list, sequence) do
    t = check_seq(list, sequence)
    if t != nil, do: t, else: get_bananas(tl(list), sequence)
  end

  defp check_seq([], _sequence), do: nil

  defp check_seq([list_head | _], [digit]) do
    {bananas, change} = list_head
    if change == digit, do: bananas, else: nil
  end

  defp check_seq([list_head | list_tail], [seq_head | seq_tail]) do
    {_bananas, change} = list_head

    if seq_head == change do
      check_seq(list_tail, seq_tail)
    else
      nil
    end
  end

  def sold_bananas(secrets, combinations) do
    sold =
      for combination <- combinations,
          do: {combination, Enum.map(secrets, fn secret -> get_bananas(secret, combination) end) |> Enum.filter(fn y -> y != nil end)} |> IO.inspect()

    Enum.map(sold, fn {combination, x} ->
      {combination, Enum.sum(x)}
    end)
    |> Enum.max_by(fn {_, x} -> x end)
  end
end

AdventOfElixir2024.Day22_2.prod()
