module Vector do
  def directions(), do: [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def mults({x, y}, factor), do: {factor * x, factor * y}

  def neg(pos), do: mult_pos(pos, -1)

  def subt(pos1, pos2), do: add_pos(pos1, neg_pos(pos2))
end
