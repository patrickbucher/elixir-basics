defmodule HigherOrder do
  def sum_of_squares(values) do
    values
    |> Enum.filter(fn v -> is_number(v) end)
    |> Enum.map(fn v -> v * v end)
    |> Enum.reduce(fn v, acc -> v + acc end)
  end
end
