defmodule PrimeWorker do
  defstruct number: -1, handled: 0
  use GenServer

  @debug false

  def start(number) do
    GenServer.start(__MODULE__, number)
  end

  def is_prime(pid, x) do
    GenServer.call(pid, {:is_prime, x})
  end

  def stats(pid) do
    GenServer.call(pid, {:stats})
  end

  def init(number) do
    if @debug, do: IO.puts("spawned worker #{number}")
    {:ok, %PrimeWorker{number: number, handled: 0}}
  end

  def handle_call({:is_prime, x}, _, state) do
    result = PrimeNumbers.is_prime(x)

    if @debug and result, do: IO.puts("worker #{state} found prime number #{x}")

    {:reply, result, %PrimeWorker{state | handled: state.handled + 1}}
  end

  def handle_call({:stats}, _, state) do
    {:reply, state.handled, state}
  end
end
