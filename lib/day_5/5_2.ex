defmodule AdventOfElixir2024.Day5_2 do
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




    updates =
      Enum.drop(lines, splitter + 1)
      |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)

    invalid_updates =
      Enum.filter(updates, fn update -> not check_update_is_valid(rules, update) end)


    corrected_updates = Enum.map(invalid_updates, fn(update) -> get_applicable_rules(update, rules) |> order_rules() end) |> IO.inspect()

    Enum.map(corrected_updates, &middle_elem/1)
    |> Enum.sum()
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

  defp get_applicable_rules(update, all_rules) do
    Enum.filter(all_rules, fn {a, b} -> Enum.member?(update, a) and Enum.member?(update, b) end)
  end

  # Assumtion: Set of all rules is a dense graph, ie every pages realtion is defined to every other page
  defp order_rules(rules) do
    order_rules(rules, [])
  end

  defp order_rules([{a,b}], order), do: [a,b] ++ order

  defp order_rules(rules, order) do
    [from, to] = Enum.zip(Enum.map(rules, &Tuple.to_list/1)) |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.uniq/1)
    largest = Enum.filter(to, fn(x) ->  not Enum.member?(from, x)end ) |> List.to_tuple()|> elem(0)
    order = [largest |order]
    rules = Enum.filter(rules, fn({a,b}) -> largest != a and largest != b end)
    order_rules(rules, order)
  end
end

AdventOfElixir2024.Day5_2.prod()
