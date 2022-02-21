defmodule Area do
  def area({:square, s}) when is_number(s) and s > 0 do
    s * s
  end

  def area({:rectangle, w, h}) when is_number(w) and is_number(h) and w > 0 and h > 0 do
    w * h
  end

  def area({:circle, r}) when is_number(r) and r > 0 do
    :math.pi() * :math.pow(r, 2)
  end

  def area(_) do
    {:invalid_shape}
  end
end
