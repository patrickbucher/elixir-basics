defmodule Factorial do
  def factorial(0), do: 1
  def factorial(x) when x > 0, do: x * factorial(x - 1)

  def factorial_tail(0), do: 1
  def factorial_tail(x) when x > 0, do: factorial_tail(x, 1)
  defp factorial_tail(0, acc), do: acc
  defp factorial_tail(x, acc), do: factorial_tail(x - 1, x * acc)
end
