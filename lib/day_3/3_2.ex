defmodule AdventOfElixir2024.Day3_2 do
  def test() do
    {:ok, input} = File.read("3_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("3_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    do_regex = ~r/do\(\)/
    dont_regex = ~r/don't\(\)/

    good_parts =
      Regex.split(do_regex, input)
      |> Enum.map(fn part -> Regex.split(dont_regex, part) |> hd() end)
      #|> IO.inspect()

    mult_op_regex = ~r/mul\(\d{1,3},\d{1,3}\)/
    numbers_in_op_regex = ~r/\d+/
    multiplications = Enum.map(good_parts, fn(part) -> Regex.scan(mult_op_regex, part)end) |> List.flatten()

    Enum.map(multiplications, fn x ->
      Regex.scan(numbers_in_op_regex, x)
      |> Enum.reduce(1, fn e, acc -> String.to_integer(hd(e)) * acc end)
    end)
    |> Enum.sum()
  end
end

AdventOfElixir2024.Day3_2.prod()
