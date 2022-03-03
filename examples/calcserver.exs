defmodule Calculator do
  def start() do
    spawn(fn -> loop(0) end)
  end

  def add(pid, x) do
    send(pid, {:add, x})
  end

  def sub(pid, x) do
    send(pid, {:sub, x})
  end

  def mul(pid, x) do
    send(pid, {:mul, x})
  end

  def div(pid, x) do
    send(pid, {:div, x})
  end

  def value(pid) do
    send(pid, {:val, self()})

    receive do
      {:ok, value} -> value
    end
  end

  defp loop(value) do
    new_value =
      receive do
        {:add, x} ->
          value + x

        {:sub, x} ->
          value - x

        {:mul, x} ->
          value * x

        {:div, x} ->
          value / x

        {:val, pid} ->
          send(pid, {:ok, value})
          value
      end

    loop(new_value)
  end
end

calculator_pid = Calculator.start()
IO.puts("initial value: #{Calculator.value(calculator_pid)}")
Calculator.add(calculator_pid, 10)
Calculator.sub(calculator_pid, 5)
Calculator.mul(calculator_pid, 3)
Calculator.div(calculator_pid, 5)
IO.puts("final value: #{Calculator.value(calculator_pid)}")
