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
      |> IO.inspect()

    partial_orders = create_partial_orders(rules) |> IO.inspect(label: "partial odrer")
    S

    updates =
      Enum.drop(lines, splitter + 1)
      |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)

    invalid_updates =
      Enum.filter(updates, fn update -> not check_update_is_valid(rules, update) end)
      |> IO.inspect()

    Enum.map(invalid_updates, &middle_elem/1)
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

  defp create_partial_orders(rules), do: create_partial_orders(rules, [])
  defp create_partial_orders([], orders), do: orders

  defp create_partial_orders([rule | other_rules], []) do
    create_partial_orders(other_rules, [Tuple.to_list(rule)])
  end

  defp create_partial_orders([rule | other_rules], orders) do
    IO.inspect(orders)
    {smaller, larger} = rule

    append_start =
      Enum.filter(orders, fn order -> List.starts_with?(order, [larger]) end)

    orders =
      Enum.reduce(append_start, orders, fn match, acc ->
        acc = List.delete(acc, match)
        new_match = [larger | match]
        [new_match | acc]
      end)

    append_end =
      Enum.filter(orders, fn order -> List.starts_with?(Enum.reverse(order), [smaller]) end)

    orders =
      Enum.reduce(append_start, orders, fn match, acc ->
        acc = List.delete(acc, match)
        new_match = match ++ [smaller]
        [new_match | acc]
      end)


    orders = if Enum.empty?(append_end) and Enum.empty?(append_start) and Enum.any?(orders, ), do: [[smaller, larger] | orders], else: orders
    create_partial_orders(other_rules, orders)
  end
end

AdventOfElixir2024.Day5_2.test()
