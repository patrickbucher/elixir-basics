defmodule SpecialNumbers do
  def even_fizz_buzz_enum(n) do
    1..100
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
    |> Enum.filter(fn x -> rem(x, 3) == 0 end)
    |> Enum.filter(fn x -> rem(x, 5) == 0 end)
    |> Enum.take(n)
  end

  def even_fizz_buzz_stream(n) do
    Stream.iterate(1, fn x -> x + 1 end)
    |> Stream.filter(fn x -> rem(x, 2) == 0 end)
    |> Stream.filter(fn x -> rem(x, 3) == 0 end)
    |> Stream.filter(fn x -> rem(x, 5) == 0 end)
    |> Enum.take(n)
  end
end
