defmodule AdventOfElixir2024.Day23_2 do
  @moduledoc "Solution for day 23, part 2 of Advent of Code 2024"

  @doc "Runs the solution with the test input"
  def test() do
    {:ok, input} = File.read("23_test_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Runs the solution with the puzzle input"
  def prod() do
    {:ok, input} = File.read("23_input.txt")
    solution(input) |> IO.inspect()
  end

  @doc "Solves the puzzle with the given input"
  @spec solution(String.t()) :: any()
  def solution(input) do
    connections =
      String.split(input, "\r\n")
      |> Enum.map(fn line -> String.split(line, "-") |> Enum.sort() end)

    devices = List.flatten(connections) |> Enum.uniq() |> IO.inspect(label: "devices")

    IO.inspect(length(devices))

    {complete_subgraphs, _} = Enum.reduce(devices, {[[]], 0}, fn device, {acc, processed_devices} ->
      IO.inspect("#{processed_devices} #{length(acc)}")
      {Enum.reduce(acc, [], fn subgraph, acc2 ->
        check_complete(device, subgraph, connections) ++ acc2
      end)
      |> Enum.uniq(), processed_devices + 1}
    end)

    largest_subgraph = Enum.max_by(complete_subgraphs, &length/1)
    Enum.sort(largest_subgraph) |> Enum.join(",")
  end

  def check_complete(device, connected_devices, connections) do
    connected_with_device =
      Enum.filter(connected_devices, fn dev2 ->
        searched_connection = [device, dev2] |> Enum.sort()
        searched_connection in connections
      end)

    if length(connected_with_device) == length(connected_devices) do
      [[device | connected_devices]] |> Enum.sort()
    else
      [[device | connected_with_device] |> Enum.sort(), connected_devices]
    end
  end
end

AdventOfElixir2024.Day23_2.prod()
