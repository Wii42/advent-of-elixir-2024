defmodule AdventOfElixir2024.Day4_2 do
  def test() do
    {:ok, input} = File.read("4_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("4_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    matrix =
      String.split(input, "\r\n")
      |> Enum.map(fn line -> String.to_charlist(line) |> as_indexed_map() end)
      |> as_indexed_map()

    word_search(matrix, String.to_charlist("MAS"))
  end

  defp as_indexed_map(list) do
    Enum.with_index(list) |> Map.new(fn {value, key} -> {key, value} end)
  end

  defp directions(), do: [{-1, -1}, {-1, 1}, {1, 1}, {1, -1}]

  defp search_in_direction(_, _, _, [], acc), do: acc

  defp search_in_direction(matrix, {xpos, ypos}, {xdir, ydir}, look_for, acc) do
    # IO.inspect("(#{xpos}, #{ypos})")

    if not (Map.has_key?(matrix, ypos) and Map.has_key?(matrix[ypos], xpos)) do
      # IO.puts("outside range (#{xpos}, #{ypos})")
      []
    else
      char_at_pos = matrix[ypos][xpos]
      # IO.inspect(<<matrix[ypos][xpos]>>)

      if char_at_pos == hd(look_for) do
        search_in_direction(matrix, {xpos + xdir, ypos + ydir}, {xdir, ydir}, tl(look_for), [
          {{xpos, ypos}, char_at_pos} | acc
        ])
      else
        []
      end
    end
  end

  defp check_all_directions(matrix, pos, look_for),
    do:
      Enum.reduce(directions(), [], fn dir, acc ->
        found_matches = search_in_direction(matrix, pos, dir, look_for, [])
        if Enum.empty?(found_matches), do: acc, else: [found_matches | acc]
      end)

  defp word_search(matrix, look_for) do
    found_matches =
      Enum.reduce(0..(map_size(matrix) - 1), [], fn y, acc ->
        acc ++
          Enum.reduce(0..(map_size(matrix[y]) - 1), [], fn x, acc ->
            acc ++ check_all_directions(matrix, {x, y}, look_for)
          end)
      end)
    #IO.inspect(found_matches)
    find_crosses(found_matches)
  end

  defp find_crosses(words) do
    a_pos_list = Enum.map(words, &get_apos/1)
    #IO.inspect(a_pos_list)
    Enum.frequencies(a_pos_list) |> Enum.filter(fn({_pos, count}) -> count == 2 end) |> length()

  end

  defp get_apos(word) do
    Enum.at(word, 1) |> elem(0)
  end
end

AdventOfElixir2024.Day4_2.prod()
