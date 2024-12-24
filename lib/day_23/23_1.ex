defmodule AdventOfElixir2024.Day23_1 do
  @moduledoc "Solution for day 23, part 1 of Advent of Code 2024"

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
      |> Enum.map(fn line -> String.split(line, "-") end)

    devices = List.flatten(connections) |> Enum.uniq() |> IO.inspect(label: "devices")

    connected_nodes =
      for [device1, device2] <- connections,
          do:
            {[device1, device2],
             Enum.filter(devices, fn other_device ->
               Enum.any?(connections, fn connection ->
                 other_device != device1 and other_device in connection and device1 in connection
               end) and
                 Enum.any?(connections, fn connection ->
                   other_device != device2 and other_device in connection and
                     device2 in connection
                 end)
             end)} |> IO.inspect()

    connected_nodes |> IO.inspect(label: "connected_nodes1")

    connected_nodes =
      Enum.map(connected_nodes, fn {[dev1, dev2], additional_devices} ->
        for device <- additional_devices,
            do: [dev1, dev2, device] |> Enum.sort() |> List.to_tuple()
      end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(&Tuple.to_list/1) |> IO.inspect(label: "connected_nodes2")

    find_historian(connected_nodes) |> length()
  end

  def find_historian(connections) do
    Enum.filter(connections, fn connection ->
      Enum.any?(connection, fn device -> String.starts_with?(device, "t") end)
    end)
  end
end

AdventOfElixir2024.Day23_1.prod()
