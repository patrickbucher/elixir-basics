defmodule SwissGradingNested do
  def grade(points, max) do
    add(multiply(ratio(points, max), 5), 1)
  end

  defp ratio(x, y) do
    x / y
  end

  defp multiply(x, y) do
    x * y
  end

  defp add(x, y) do
    x + y
  end

  defp round(x, precision) do
    round(x * 1 / precision) * precision
  end
end
