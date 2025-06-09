defmodule FractionProcess do
  def start(init \\ %Fraction{dividend: 0, divisor: 1}) do
    spawn(fn -> run(init) end)
  end

  def add(pid, fraction), do: send(pid, {:add, fraction})
  def subtract(pid, fraction), do: send(pid, {:subtract, fraction})
  def multiply(pid, fraction), do: send(pid, {:multiply, fraction})
  def divide(pid, fraction), do: send(pid, {:divide, fraction})

  def compute(pid) do
    send(pid, {:compute, self()})

    receive do
      {:result, result} -> result
    end
  end

  defp run(acc) do
    acc =
      receive do
        {:add, frac} ->
          Fraction.add(acc, frac)

        {:subtract, frac} ->
          Fraction.subtract(acc, frac)

        {:multiply, frac} ->
          Fraction.multiply(acc, frac)

        {:divide, frac} ->
          Fraction.divide(acc, frac)

        {:compute, caller} ->
          acc = Fraction.cancel(acc)
          send(caller, {:result, acc})
          acc
      end

    run(acc)
  end
end
