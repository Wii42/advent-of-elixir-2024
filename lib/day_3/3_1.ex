defmodule AdventOfElixir2024.Day3_1 do
  def test() do
    {:ok, input} = File.read("3_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("3_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    mult_op_regex = ~r/mul\(\d{1,3},\d{1,3}\)/
    numbers_in_op_regex = ~r/\d+/
    multiplications = Regex.scan(mult_op_regex, input)

    Enum.map(multiplications, fn x ->
      Regex.scan(numbers_in_op_regex, hd(x))
      |> Enum.reduce(1, fn e, acc -> String.to_integer(hd(e)) * acc end)
    end)
    |> Enum.sum()
  end
end

AdventOfElixir2024.Day3_1.prod()
