defmodule AdventOfElixir2024.Day24_1 do
  @moduledoc "Solution for day 24, part 1 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("24_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("24_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    [initial_wires, gates] = input |> String.split("\r\n\r\n")

    initial_wires =
      initial_wires
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [wire, value] = String.split(line, ": ")
        {wire, String.to_integer(value)}
      end)
      |> Enum.into(%{})

    # gates have the form {input_var1, operator, input_var2, result_var}
    gates =
      gates
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [expr, result_var] = String.split(line, " -> ")
        (String.split(expr, " ") ++ [result_var]) |> List.to_tuple()
      end)

    wires = eval_gates(gates, initial_wires)

    get_value(wires, "z")
  end

  def can_eval_gate({input_var1, _operator, input_var2, _result_var}, wires),
    do: wires[input_var1] != nil and wires[input_var2] != nil

  def eval_gate({input_var1, operator, input_var2, result_var}, wires) do
    input1 = wires[input_var1]
    input2 = wires[input_var2]
    result = run_gate(input1, operator, input2)
    Map.put_new(wires, result_var, result)
  end

  defp run_gate(x, "AND", y), do: Bitwise.band(x, y)
  defp run_gate(x, "OR", y), do: Bitwise.bor(x, y)
  defp run_gate(x, "XOR", y), do: Bitwise.bxor(x, y)

  def eval_gates([], wires), do: wires

  def eval_gates(gates, wires) do
    {new_wires, unevaluated} =
      Enum.reduce(gates, {wires, []}, fn gate, {acc, unevaluated_gates} ->
        if can_eval_gate(gate, acc),
          do: {eval_gate(gate, acc), unevaluated_gates},
          else: {acc, [gate | unevaluated_gates]}
      end)

    eval_gates(unevaluated, new_wires)
  end

  def get_value(wires, variable) do
    Enum.filter(wires, fn {wire, _} -> String.starts_with?(wire, variable) end)
    |> Enum.sort_by(fn {wire, _} -> wire end, :desc)
    |> Enum.map(fn {_, value} -> value end)
    |> Integer.undigits(2)
  end
end

AdventOfElixir2024.Day24_1.test()
