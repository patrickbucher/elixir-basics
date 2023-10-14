defmodule PrimeSieve do
  def stream() do
    Stream.unfold([], fn
      [] -> {2, [2]}
      [h|t] -> next(h+1, [h|t])
    end)
  end

  defp next(n, primes) do
    if Enum.any?(primes, fn p -> rem(n, p) == 0 end) do
      next(n+1, primes)
    else
      {n, [n|primes]}
    end
  end
end
