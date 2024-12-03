defmodule AdventOfElixir2024.Day2_1 do
  def test() do
    {:ok, input} = File.read("2_test_input.txt")
    solution(input) |> IO.inspect()
  end

  def prod() do
    {:ok, input} = File.read("2_input.txt")
    solution(input) |> IO.inspect()
  end

  def solution(input) do
    lines = String.split(input, "\r\n")

    array =
      for line <- lines,
          do: String.split(line, "\s", trim: true) |> Enum.map(&String.to_integer/1)

    safe_list =
      for line <- array,
          do: Enum.reduce(line, {nil, nil, true}, &comparator/2)

    Enum.map(safe_list, fn {_, _, is_safe} -> is_safe end)
    |> Enum.reduce(0, fn bool, acc -> if bool == true, do: acc+1, else: acc end)
  end

  # acc has the form {prev_value, order, is_safe}
  defp comparator(elem, acc) do
    case acc do
      {_, _, false} ->
        {nil, nil, false}

      {nil, nil, true} ->
        {elem, nil, true}

      {prev_value, nil, true} ->
        change = elem - prev_value

        if in_range?(abs(change)) do
          order = if change > 0, do: :asc, else: :desc
          {elem, order, true}
        else
          {nil, nil, false}
        end

      {prev_value, order, true} ->
        change = elem - prev_value
        # IO.inspect(elem)
        # IO.inspect(acc)
        # IO.inspect(change)

        signed_change =
          case order do
            :asc -> change
            :desc -> -change
          end

        is_in_range = in_range?(signed_change)
        #IO.inspect(is_in_range)
        if is_in_range, do: {elem, order, true}, else: {nil, nil, false}
    end
  end

  defp in_range?(x), do: x >= 1 and x <= 3
end

AdventOfElixir2024.Day2_1.prod()
