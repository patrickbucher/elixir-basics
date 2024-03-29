defmodule SwissGrading do
  def grade(points, max) do
    point_ratio = ratio(points, max)
    temp_grade = multiply(point_ratio, 5)
    exact_grade = add(temp_grade, 1)
    round(exact_grade, 0.1)
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
