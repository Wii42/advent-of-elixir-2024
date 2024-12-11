defmodule AdventOfElixir2024.Day9_1 do
  def test() do
    {:ok, input} = File.read("9_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("9_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    list = String.to_charlist(input) |> Enum.map(fn x -> String.to_integer(<<x>>) end)

    grouped_list = Enum.chunk_every(list, 2) |> Enum.with_index()

    storage =
      Enum.reduce(grouped_list, [], fn {x, index}, acc ->
        file = Enum.at(x, 0)
        free = Enum.at(x, 1, 0)
        acc = List.duplicate(index, file) ++ acc
        acc = List.duplicate(nil, free) ++ acc
        acc
      end)
      |> Enum.reverse()

    storage = compact_files(storage, 0, length(storage) - 1)

    list_to_string(storage) |> IO.puts()
    checksum(storage)
  end

  def list_to_string(list) do
    Enum.map(list, fn x ->
      case x do
        nil -> "."
        _ -> Integer.to_string(x)
      end
    end)
    |> Enum.join(" ")
  end

  defp compact_files(storage, index_l, index_r) when index_l >= index_r, do: storage

  defp compact_files(storage, index_l, index_r) do
    elem_l = Enum.at(storage, index_l)

    if elem_l == nil do
      swap_file_index = next_index_file(storage, index_r)

      if index_l >= swap_file_index do
        storage
      else
        swap_file = Enum.at(storage, swap_file_index)
        storage = List.replace_at(storage, index_l, swap_file)
        storage = List.replace_at(storage, swap_file_index, nil)
        #list_to_string(storage) |> IO.puts()
        if rem(index_l, 100) == 0, do: IO.inspect({index_l, swap_file_index})
        compact_files(storage, index_l + 1, swap_file_index)
      end
    else
      compact_files(storage, index_l + 1, index_r)
    end
  end

  defp next_index_file(storage, file_index) do
    free_elem = Enum.at(storage, file_index)

    if(free_elem != nil) do
      file_index
    else
      next_index_file(storage, file_index - 1)
    end
  end

  defp checksum(storage),
    do:
      Enum.with_index(storage)
      |> Enum.map(fn {id, index} ->
        id = if id == nil, do: 0, else: id
        id * index
      end)
      |> Enum.sum()
end

AdventOfElixir2024.Day9_1.prod()
