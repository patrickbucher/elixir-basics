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

  defp run(state) do
    state =
      receive do
        {:add, fraction} ->
          Fraction.add(state, fraction)

        {:subtract, fraction} ->
          Fraction.subtract(state, fraction)

        {:multiply, fraction} ->
          Fraction.multiply(state, fraction)

        {:divide, fraction} ->
          Fraction.divide(state, fraction)

        {:compute, caller} ->
          state = Fraction.cancel(state)
          send(caller, {:result, state})
          state
      end

    run(state)
  end
end
