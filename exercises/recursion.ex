defmodule Recursion do
  def list_len([]), do: 0
  def list_len([_ | tail]), do: 1 + list_len(tail)

  def range(a, b) when a == b, do: [a]
  def range(a, b) when a < b, do: [a | range(a + 1, b)]

  def positive([]), do: []
  def positive([head | tail]) when head > 0, do: [head | positive(tail)]
  def positive([head | tail]) when head <= 0, do: positive(tail)
end

defmodule RecursionTailCall do
  def list_len([]), do: 0
  def list_len(l), do: list_len(l, 0)
  defp list_len([], acc), do: acc
  defp list_len([_ | tail], acc), do: list_len(tail, acc + 1)

  def range(a, b) when a == b, do: [a]
  def range(a, b) when a < b, do: range(a, b, [])
  defp range(a, b, acc) when a == b, do: [b | acc]
  defp range(a, b, acc) when a < b, do: range(a, b - 1, [b | acc])

  def positive([]), do: []
  def positive([head | tail]), do: positive([head | tail], [])
  defp positive([], acc), do: Enum.reverse(acc)
  defp positive([head | tail], acc) when head > 0, do: positive(tail, [head | acc])
  defp positive([head | tail], acc) when head <= 0, do: positive(tail, acc)
end
