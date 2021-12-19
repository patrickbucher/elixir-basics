defmodule SwissGrading do
  def grade(points, max) do
    points
    |> ratio(max)
    |> multiply(5)
    |> add(1)
    |> round(0.1)
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
    round(x * 1/precision) * precision
  end
end
