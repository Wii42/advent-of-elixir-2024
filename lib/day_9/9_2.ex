defmodule AdventOfElixir2024.Day9_2 do
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

    storage = Enum.chunk_every(list, 2) |> Enum.with_index()

    storage = fix_last_storage_element(storage)

    storage = Enum.map(storage, fn {list, index} -> {list, index, false} end)

    storage = compact_files(storage, [])

    list_to_string(storage) |> IO.puts()
    checksum(storage)
  end

  def list_to_string(list) do
    storage_to_list(list)
    |> Enum.map(fn x ->
      case x do
        nil -> "."
        _ -> Integer.to_string(x)
      end
    end)
    |> Enum.join("")
  end

  defp storage_to_list(storage),
    do:
      Enum.reduce(storage, [], fn {x, index, _}, acc ->
        file = Enum.at(x, 0)
        free = Enum.at(x, 1, 0)
        acc = List.duplicate(index, file) ++ acc
        acc = List.duplicate(nil, free) ++ acc
        acc
      end)
      |> Enum.reverse()

  defp compact_files([], uncompactable_storage), do: uncompactable_storage

  defp compact_files(storage, uncompactable_storage) do
    reversed_storage = Enum.reverse(storage)
    [head | reversed_rest] = reversed_storage
    head_already_moved? = elem(head, 2)

    if head_already_moved? do
      IO.inspect(head)
      compact_files(Enum.reverse(reversed_rest), [head | uncompactable_storage])
    else
      {found_space, storage} = find_free_space(head, Enum.reverse(reversed_rest), [])

      if(found_space) do
        storage = update_last(storage, head)
        {_, id, _} = head
        if rem(id, 100) == 0, do: IO.inspect(id, label: "Moved")
        compact_files(storage, uncompactable_storage)
      else
        storage_length = length(storage)
        if rem(storage_length, 100) == 0, do: IO.puts(storage_length)
        compact_files(storage, [head | uncompactable_storage])
      end
    end
  end

  defp find_free_space(_, [], consumed_storage), do: {false, consumed_storage}

  defp find_free_space(element, storage, consumed_storage) do
    [head | rest_storage] = storage
    {[hd_file_size, hd_free_size], hd_id, hd_moved?} = head
    {[elem_file_size, _], elem_id, _} = element

    if(elem_file_size <= hd_free_size) do
      head = {[hd_file_size, 0], hd_id, hd_moved?}
      element = {[elem_file_size, hd_free_size - elem_file_size], elem_id, true}
      new_storage = consumed_storage ++ [head, element] ++ rest_storage
      {true, new_storage}
    else
      find_free_space(element, rest_storage, consumed_storage ++ [head])
    end
  end

  defp update_last(storage, element) do
    reversed_storage = Enum.reverse(storage)
    [last | rest] = reversed_storage
    {[file_size, free_size], id, moved?} = last
    {[elem_file_size, elem_free_size], _, _} = element
    last = {[file_size, free_size + elem_file_size + elem_free_size], id, moved?}
    [last | rest] |> Enum.reverse()
  end

  defp fix_last_storage_element(storage) do
    storage = Enum.reverse(storage)
    [last | rest] = storage
    {list, id} = last
    file_size = Enum.at(list, 0)
    free_size = Enum.at(list, 1, 0)
    last = {[file_size, free_size], id}
    [last | rest] |> Enum.reverse()
  end

  defp checksum(storage) do
    storage_to_list(storage)
    |> Enum.with_index()
    |> Enum.map(fn {id, index} ->
      id = if id == nil, do: 0, else: id
      id * index
    end)
    |> Enum.sum()
  end
end

AdventOfElixir2024.Day9_2.prod()
