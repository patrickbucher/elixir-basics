defmodule FractionServer do
  use GenServer

  def start(fraction \\ %Fraction{dividend: 0, divisor: 1}) do
    GenServer.start(FractionServer, fraction)
  end

  def add(pid, fraction), do: GenServer.cast(pid, {:add, fraction})
  def subtract(pid, fraction), do: GenServer.cast(pid, {:subtract, fraction})
  def multiply(pid, fraction), do: GenServer.cast(pid, {:multiply, fraction})
  def divide(pid, fraction), do: GenServer.cast(pid, {:divide, fraction})

  def compute(pid), do: GenServer.call(pid, {:compute})

  @impl GenServer
  def init(fraction) do
    {:ok, fraction}
  end

  @impl GenServer
  def handle_cast({:add, fraction}, state) do
    {:noreply, Fraction.add(state, fraction)}
  end

  @impl GenServer
  def handle_cast({:subtract, fraction}, state) do
    {:noreply, Fraction.subtract(state, fraction)}
  end

  @impl GenServer
  def handle_cast({:multiply, fraction}, state) do
    {:noreply, Fraction.multiply(state, fraction)}
  end

  @impl GenServer
  def handle_cast({:divide, fraction}, state) do
    {:noreply, Fraction.divide(state, fraction)}
  end

  @impl GenServer
  def handle_call({:compute}, _, state) do
    state = Fraction.cancel(state)
    {:reply, state, state}
  end
end
