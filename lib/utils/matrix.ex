defmodule Matrix do
  @type matrix :: %{integer() => %{integer() => char()}}

  defp line_delimiter(), do: "\r\n"

  @spec from_string([[any()]]) :: matrix()
  def from_string(string_input) do
    String.split(string_input, line_delimiter())
    |> Enum.map(fn line -> String.to_charlist(line) |> as_indexed_map() end)
    |> as_indexed_map()
  end

  defp as_indexed_map(list) do
    Enum.with_index(list) |> Map.new(fn {value, key} -> {key, value} end)
  end

  def to_string(matrix) do
    Enum.map(Map.values(matrix), fn line -> List.to_string(Map.values(line)) end)
    |> Enum.join(line_delimiter())
  end

  def print(matrix) do
    Matrix.to_string(matrix) |> IO.puts()
    matrix
  end

  def find_value(matrix, value) do
    matrix
    |> Enum.find(fn {_outer_key, inner_map} ->
      case inner_map do
        %{} -> Enum.any?(inner_map, fn {_inner_key, val} -> val == value end)
        _ -> false
      end
    end)
    |> case do
      {outer_key, inner_map} ->
        {inner_key, _} = Enum.find(inner_map, fn {_inner_key, val} -> val == value end)
        {outer_key, inner_key}

      nil ->
        nil
    end
  end

  def filter(matrix, fun) do
    Enum.map(matrix, fn _key, row -> Map.filter(row, fn {_, val} -> fun.(val) end) end)
  end
end
