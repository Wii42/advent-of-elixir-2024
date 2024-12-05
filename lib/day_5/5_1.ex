defmodule AdventOfElixir2024.Day5_1 do
  def test() do
    {:ok, input} = File.read("5_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("5_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    lines = String.split(input, "\r\n")

    splitter = index_of_elem(lines, "")

    rules =
      Enum.take(lines, splitter)
      |> Enum.map(fn x ->
        String.split(x, "|") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> IO.inspect()

    updates =
      Enum.drop(lines, splitter + 1)
      |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)

    valid_updates = Enum.filter(updates, fn update -> check_update_is_valid(rules, update) end)

    Enum.map(valid_updates, &middle_elem/1) |> Enum.sum()


  end

  def index_of_elem(list, elem) do
    indexed_elem = Enum.with_index(list) |> Enum.find(fn {x, _index} -> x == elem end)
    if indexed_elem == nil, do: nil, else: elem(indexed_elem, 1)
  end

  defp check_update_is_valid(rules, update) do
    Enum.all?(rules, fn {page1, page2} ->
      page1_index = index_of_elem(update, page1)
      page2_index = index_of_elem(update, page2)
      if page1_index == nil or page2_index == nil, do: true, else: page1_index < page2_index
    end)
  end

  defp middle_elem(list) do
    middle_index = length(list) |> div(2)
    Enum.at(list, middle_index)
  end
end

AdventOfElixir2024.Day5_1.prod()
