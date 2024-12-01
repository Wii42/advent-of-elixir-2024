defmodule AdventOfElixir2024Test do
  use ExUnit.Case
  doctest AdventOfElixir2024

  test "greets the world" do
    assert AdventOfElixir2024.hello() == :world
  end
end
